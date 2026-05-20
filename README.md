# Aakash Choudhary — Developer Portfolio

A personal developer portfolio built with **Flutter Web**, featuring deep-linked routing, a data-driven content layer, and an interactive 3D skills sphere.

**Live:** https://knowme-299be.web.app/

---

## Tech Stack

- **Flutter Web** — single-page app with multi-page deep-linked routing
- **BLoC** — strict event-driven state management
- **Clean Architecture** — feature-first, layered (data / domain / presentation)
- **go_router** — URL-based navigation with browser back/forward support
- **Firebase Hosting** — deployed with caching and Gzip/Brotli compression

## Features

- Responsive layout across mobile, tablet, and desktop
- Data-driven content via a single local JSON asset (`assets/data/portfolio_data.json`)
- Animated 3D skills sphere (HTML/JS embedded via platform view)
- Sections: Hero, About, Skills, Experience, Projects, Contact
- Deep-linked routes: `/`, `/experience`, `/projects`, `/projects/:id`
- Shimmer loading state during data bootstrap

## Project Structure

```
lib/
 ├── core/           # DI, error handling, utils
 ├── features/
 │    └── portfolio/ # data / domain / presentation layers
 ├── routes/         # go_router configuration
 └── main.dart
assets/
 ├── data/portfolio_data.json   # single source of truth for all content
 ├── images/
 └── html/skills_sphere_animation.html
```

## Running Locally

```bash
flutter pub get
flutter run -d chrome
```

## Building for Web

```bash
flutter build web --release
```
