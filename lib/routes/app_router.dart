import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/portfolio/presentation/pages/home_page.dart';
import '../features/portfolio/presentation/pages/experience_page.dart';
import '../features/portfolio/presentation/pages/projects_page.dart';
import '../features/portfolio/presentation/pages/project_detail_page.dart';
import '../features/portfolio/presentation/pages/not_found_page.dart';

CustomTransitionPage<T> _fadeSlidePage<T>({
  required String name,
  required Widget child,
  LocalKey? key,
}) {
  return CustomTransitionPage<T>(
    key: key,
    name: name,
    child: child,
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    transitionsBuilder: (context, animation, _, child) {
      final curve = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curve,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.015),
            end: Offset.zero,
          ).animate(curve),
          child: child,
        ),
      );
    },
  );
}

final appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      pageBuilder: (context, state) => _fadeSlidePage(
        name: 'Aakash Choudhary — Mobile Developer',
        child: const HomePage(),
      ),
    ),
    GoRoute(
      path: '/experience',
      name: 'experience',
      pageBuilder: (context, state) => _fadeSlidePage(
        name: 'Experience — Aakash Choudhary',
        child: const ExperiencePage(),
      ),
    ),
    GoRoute(
      path: '/projects',
      name: 'projects',
      pageBuilder: (context, state) => _fadeSlidePage(
        name: 'Projects — Aakash Choudhary',
        child: const ProjectsPage(),
      ),
    ),
    GoRoute(
      path: '/projects/:id',
      name: 'project-detail',
      pageBuilder: (context, state) => _fadeSlidePage(
        key: ValueKey(state.pathParameters['id']),
        name: 'Project — Aakash Choudhary',
        child: ProjectDetailPage(id: state.pathParameters['id']!),
      ),
    ),
  ],
);
