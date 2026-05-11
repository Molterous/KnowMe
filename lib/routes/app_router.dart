import 'package:go_router/go_router.dart';
import '../core/utils/core_strings.dart';
import '../core/utils/app_strings.dart';
import '../features/portfolio/presentation/pages/home_page.dart';
import '../features/portfolio/presentation/pages/not_found_page.dart';

final appRouter = GoRouter(
  initialLocation: CoreStrings.routeHome,
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    GoRoute(
      path: CoreStrings.routeHome,
      name: CoreStrings.routeNameHome,
      pageBuilder: (context, state) => const NoTransitionPage(
        name: AppStrings.homePageTitle,
        child: HomePage(),
      ),
    ),
  ],
);
