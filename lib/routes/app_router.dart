import 'package:go_router/go_router.dart';
import '../features/portfolio/presentation/pages/home_page.dart';
import '../features/portfolio/presentation/pages/experience_page.dart';
import '../features/portfolio/presentation/pages/projects_page.dart';
import '../features/portfolio/presentation/pages/project_detail_page.dart';
import '../features/portfolio/presentation/pages/not_found_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      pageBuilder: (context, state) => const NoTransitionPage(
        name: 'Aakash Choudhary — Mobile Developer',
        child: HomePage(),
      ),
    ),
    GoRoute(
      path: '/experience',
      name: 'experience',
      pageBuilder: (context, state) => const NoTransitionPage(
        name: 'Experience — Aakash Choudhary',
        child: ExperiencePage(),
      ),
    ),
    GoRoute(
      path: '/projects',
      name: 'projects',
      pageBuilder: (context, state) => const NoTransitionPage(
        name: 'Projects — Aakash Choudhary',
        child: ProjectsPage(),
      ),
    ),
    GoRoute(
      path: '/projects/:id',
      name: 'project-detail',
      pageBuilder: (context, state) => NoTransitionPage(
        name: 'Project — Aakash Choudhary',
        child: ProjectDetailPage(id: state.pathParameters['id']!),
      ),
    ),
  ],
);
