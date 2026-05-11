import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ds_core/ds_core.dart';
import 'core/di/locator.dart';
import 'features/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'features/portfolio/presentation/pages/home_page.dart';
import 'features/portfolio/presentation/pages/preloader_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  bool _preLoaderDone = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PortfolioBloc>()..add(const PortfolioDataRequested()),
      child: MaterialApp(
        title: 'Aakash Choudhary',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const HomePage(),
        builder: (context, child) {
          if (!_preLoaderDone) {
            return PreloaderPage(
              onComplete: () => setState(() => _preLoaderDone = true),
            );
          }
          final actualChild = child ?? const SizedBox.shrink();
          if (!ResponsiveUtils.isDesktop(context)) return actualChild;
          return CursorSpotlight(radius: 180, child: actualChild);
        },
      ),
    );
  }
}
