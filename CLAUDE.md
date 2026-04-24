# claude.md — Senior-Level Flutter Web Architecture (BLoC + Clean Architecture)

## Purpose

Opinionated, production-grade standards for building **scalable Flutter Web apps** using **BLoC (not Cubit)** with **feature-first clean architecture**, strong **DI**, and web-aware performance.

---

## 0. Core Principles

* **Separation of concerns**: UI ≠ business logic ≠ data access
* **Feature-first modularity**
* **Predictable state via BLoC (events → states)**
* **Testability by default** (use cases, repositories mocked)
* **Web-first thinking** (routing, performance, accessibility)

---

## 1. Project Structure (Feature-First + Clean Architecture)

```
lib/
 ├── core/                    # cross-cutting
 │    ├── di/                 # get_it setup
 │    ├── error/              # failures, exceptions, mappers
 │    ├── network/            # dio client, interceptors
 │    ├── theme/              # design tokens, themes
 │    ├── utils/
 │    └── widgets/            # shared widgets
 │
 ├── features/
 │    ├── auth/
 │    │    ├── data/
 │    │    │    ├── datasources/
 │    │    │    ├── models/
 │    │    │    └── repositories/
 │    │    ├── domain/
 │    │    │    ├── entities/
 │    │    │    ├── repositories/
 │    │    │    └── usecases/
 │    │    ├── presentation/
 │    │    │    ├── bloc/
 │    │    │    │    ├── auth_bloc.dart
 │    │    │    │    ├── auth_event.dart
 │    │    │    │    └── auth_state.dart
 │    │    │    ├── pages/
 │    │    │    └── widgets/
 │    │    └── auth_module.dart  # DI registration
 │    │
 │    └── dashboard/...
 │
 ├── routes/
 │    └── app_router.dart
 │
 └── main.dart
```

### Rules

* **NO cross-feature imports** (except via domain contracts)
* **UI never touches data layer**
* Each feature owns its full stack (data/domain/presentation)

---

## 2. State Management — BLoC (STRICT)

### Flow

```
UI → Event → Bloc → UseCase → Repository → DataSource → State → UI
```

### Hard Rules

* Bloc **calls UseCases only** (never repositories directly)
* UI **dispatches events only** (no logic)
* States are **immutable + Equatable**
* One responsibility per Bloc (avoid god blocs)

### Naming

* Events: `LoginRequested`, `PageOpened`, `RetryPressed`
* States: `Initial`, `Loading`, `Success`, `Failure`

### Base Patterns

* Create `BaseState` with: `status`, `error`, `data?`
* Standardize statuses: `initial | loading | success | failure`

### Global Observability

* Implement `BlocObserver` for logging, analytics, error tracking

---

## 3. Domain Layer (UseCases are Mandatory)

* All business logic lives in **UseCases**
* Each use case does **one thing**

```
class LoginUser {
  final AuthRepository repo;
  Future<Either<Failure, User>> call(LoginParams params);
}
```

### Rules

* No Flutter imports in domain
* Pure Dart → easily testable

---

## 4. Data Layer

### Responsibilities

* API calls, caching, persistence

### Structure

* `datasources/` (remote/local)
* `models/` (DTO ↔ entity mapping)
* `repositories/` (implementation)

### Rules

* Convert exceptions → **Failure**
* Never leak DTOs to UI/domain

---

## 5. Dependency Injection (MANDATORY)

Use **get_it** (optionally with injectable)

### Setup

* `core/di/locator.dart`
* Each feature has `*_module.dart`

### Rules

* Register at app start
* Use **lazySingleton** for services
* Use **factory** for Blocs

---

## 6. Routing (Web-First)

Use `go_router`

### Requirements

* URL-based navigation
* Deep linking support
* Browser back/forward works

### Rules

* Centralized router
* Route guards for auth

---

## 7. Responsiveness (NON-NEGOTIABLE)

### Breakpoints

* Mobile < 600
* Tablet 600–1024
* Desktop > 1024

### Rules

* No fixed widths
* Prefer **constraints-based layouts**
* Desktop-first UX for web apps

---

## 8. Performance (CRITICAL FOR WEB)

### Widget Rules

* Use `const` everywhere possible
* Split widgets aggressively
* Avoid rebuild-heavy patterns

### Avoid

* `Opacity` (use colors with alpha)
* `Clip.*` unless necessary
* `IntrinsicHeight/Width`

### Lists

* Always use builders (`ListView.builder`)

### Assets

* Optimize images
* Lazy load heavy content

---

## 9. Networking

Use **Dio**

### Must Have

* Interceptors (auth, logging, retry)
* Timeout handling
* Central error mapping

---

## 10. Error Handling (Standardized)

Use **Either<Failure, T>** everywhere.

### Error Modeling (MANDATORY)

Define a **closed set of error types using enums + classes** for consistency and easy evolution.

```
enum ErrorType {
  network,
  server,
  cache,
  unauthorized,
  validation,
  unknown,
}

class Failure {
  final ErrorType type;
  final String message;
  final int? code;

  const Failure({required this.type, required this.message, this.code});
}
```

### Base Exception → Failure Mapping

```
abstract class AppException implements Exception {
  final String message;
  final int? code;
  const AppException(this.message, {this.code});
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

class ServerException extends AppException {
  const ServerException(super.message, {super.code});
}

Failure mapExceptionToFailure(AppException e) {
  switch (e.runtimeType) {
    case NetworkException:
      return Failure(type: ErrorType.network, message: e.message, code: e.code);
    case ServerException:
      return Failure(type: ErrorType.server, message: e.message, code: e.code);
    default:
      return Failure(type: ErrorType.unknown, message: e.message, code: e.code);
  }
}
```

### Rules

* Data layer throws **AppException only**
* Repository maps **Exception → Failure**
* Domain/UI deals only with **Failure**
* Never pass raw exceptions upward

---

## 10.1 Base Classes (FOR SCALABILITY)

### Base UseCase

```
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
```

### Base Bloc State

```
enum Status { initial, loading, success, failure }

abstract class BaseState extends Equatable {
  final Status status;
  final Failure? error;

  const BaseState({this.status = Status.initial, this.error});

  @override
  List<Object?> get props => [status, error];
}
```

### Base Bloc (Optional but Recommended)

```
abstract class BaseBloc<E, S extends BaseState> extends Bloc<E, S> {
  BaseBloc(super.initialState);

  void emitLoading(Emitter<S> emit, S state) {
    emit(state.copyWith(status: Status.loading));
  }

  void emitSuccess(Emitter<S> emit, S state) {
    emit(state.copyWith(status: Status.success));
  }

  void emitFailure(Emitter<S> emit, S state, Failure failure) {
    emit(state.copyWith(status: Status.failure, error: failure));
  }
}
```

### copyWith Rule

* Every state MUST implement `copyWith`
* Enables predictable immutable updates

---

## 11. Environment & Config

### Environments

* dev
* staging
* prod

### Setup

* Separate configs
* Base URLs per env
* Feature flags if needed

---

## 12. Theming & Design System

* Central design tokens
* No hardcoded values
* Support light/dark

---

## 13. Accessibility (Web Important)

* Semantic labels
* Keyboard navigation
* Focus management

---

## 14. Testing Strategy

### Required

* Unit tests (UseCases)
* Bloc tests (state transitions)
* Widget tests (UI)

### Optional

* Integration / e2e tests

---

## 15. Build & Deployment

```
flutter build web --release
```

### Hosting

* Firebase / Vercel / CDN

### Rules

* Enable caching
* Gzip/Brotli

---

## 16. Security

* No secrets in frontend
* Validate all inputs
* HTTPS only

---

## 17. Common Pitfalls

* Calling repositories from UI/Bloc directly
* Treating web like mobile
* Ignoring performance early
* Monolithic Blocs

---

## 18. Golden Rules

* **Bloc → UseCase → Repository → DataSource** (never break this)
* Keep UI dumb
* Prefer composition over inheritance
* Optimize for web constraints early

---

## Summary

A senior-grade Flutter Web app is:

* **Modular** (feature-first)
* **Predictable** (BLoC)
* **Testable** (clean domain)
* **Performant** (web-optimized)
* **Scalable** (DI + strict layering)

---

## 19. This Project — Portfolio

### Overview

Personal developer portfolio for **Aakash Choudhary** (Mobile Developer). A Flutter Web single-page app with deep-linked multi-page routing, data-driven via a local JSON asset, and an interactive 3D skills sphere embedded via HTML.

### Key Facts

* **Data source**: `assets/data/portfolio_data.json` — single JSON file drives all content (personal info, experience, projects, skills, education). No network calls.
* **Local module**: `./module` (`ds_core`) — shared design system / core utilities referenced as a path dependency.
* **Skills sphere**: `assets/html/skills_sphere_animation.html` — loaded inside the app as a web view for the animated 3D sphere in the skills section.
* **Routes**: `/` (home), `/experience`, `/projects`, `/projects/:id` — all use `NoTransitionPage` for instant navigation.
* **Preloader**: `PreloaderPage` bootstraps the app and triggers `PortfolioDataRequested` before showing content.
* **Shimmer**: `HomeShimmer` is shown during loading state.

### Actual Project Tree

```
Portfolio/
 ├── assets/
 │    ├── data/
 │    │    └── portfolio_data.json       # single source of truth for all content
 │    ├── images/
 │    │    └── self.jpg
 │    └── html/
 │         └── skills_sphere_animation.html
 │
 ├── lib/
 │    ├── core/
 │    │    ├── di/locator.dart
 │    │    ├── error/
 │    │    │    ├── exception_mapper.dart
 │    │    │    ├── exceptions.dart
 │    │    │    └── failures.dart
 │    │    └── utils/
 │    │         ├── app_assets.dart
 │    │         └── app_strings.dart
 │    │
 │    ├── features/
 │    │    └── portfolio/
 │    │         ├── data/
 │    │         │    ├── datasources/portfolio_local_datasource.dart
 │    │         │    ├── models/portfolio_model.dart
 │    │         │    └── repositories/portfolio_repository_impl.dart
 │    │         ├── domain/
 │    │         │    ├── entities/portfolio_entity.dart
 │    │         │    ├── repositories/portfolio_repository.dart
 │    │         │    └── usecases/get_portfolio_data.dart
 │    │         └── presentation/
 │    │              ├── bloc/
 │    │              │    ├── portfolio_bloc.dart
 │    │              │    ├── portfolio_event.dart
 │    │              │    └── portfolio_state.dart
 │    │              ├── pages/
 │    │              │    ├── home_page.dart
 │    │              │    ├── experience_page.dart
 │    │              │    ├── projects_page.dart
 │    │              │    ├── project_detail_page.dart
 │    │              │    ├── preloader_page.dart
 │    │              │    └── not_found_page.dart
 │    │              └── widgets/
 │    │                   ├── home_content.dart
 │    │                   ├── home_shimmer.dart
 │    │                   ├── nav_bar.dart
 │    │                   ├── portfolio_footer.dart
 │    │                   └── sections/
 │    │                        ├── hero_section.dart
 │    │                        ├── about_section.dart
 │    │                        ├── skills_section.dart
 │    │                        ├── experience_preview_section.dart
 │    │                        ├── projects_preview_section.dart
 │    │                        └── contact_section.dart
 │    │
 │    ├── routes/app_router.dart
 │    └── main.dart
 │
 └── module/                            # ds_core local design system package
```

### Domain Entities (portfolio_entity.dart)

* `PortfolioEntity` — root: personal, about, experience[], projects[], skills, education
* `PersonalEntity` — name, title, subtitle, tagline, email, phone, location, available, links
* `AboutEntity` — bio, highlights[], personalityChips[]
* `ExperienceEntity` — id, company, role, type, location, duration, current, summary, highlights[], metrics[], tech[]
* `ProjectEntity` — id, title, subtitle, platform[], status, description, highlights[], tech[], metrics[]
* `SkillsEntity` — languages[], frameworks[], architecture[], tools[], cloud[], expertise[]
* `EducationEntity` — degree, institution, affiliation, cgpa, year

### BLoC Flow

```
PreloaderPage → PortfolioDataRequested → PortfolioBloc
  → GetPortfolioData (use case)
  → PortfolioRepositoryImpl
  → PortfolioLocalDataSource (reads JSON asset)
  → PortfolioState { status, data, error }
  → HomeContent / pages consume via BlocBuilder
```
