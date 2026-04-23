import 'package:flutter/material.dart';
import 'package:ds_core/ds_core.dart';

class PreloaderPage extends StatefulWidget {
  const PreloaderPage({super.key, required this.onComplete});
  final VoidCallback onComplete;

  @override
  State<PreloaderPage> createState() => _PreloaderPageState();
}

class _PreloaderPageState extends State<PreloaderPage>
    with TickerProviderStateMixin {
  late final AnimationController _lineController;
  late final AnimationController _fadeController;
  late final Animation<double> _lineWidth;
  late final Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();

    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _lineWidth = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _lineController, curve: Curves.easeInOutCubic),
    );

    _fadeOut = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _lineController.forward().then((_) async {
      await Future.delayed(const Duration(milliseconds: 300));
      await _fadeController.forward();
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _lineController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeOut,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'AC.',
                style: AppTextStyles.displayLarge.copyWith(
                  color: AppColors.primaryText,
                  letterSpacing: -2,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: 80,
                height: 2,
                child: AnimatedBuilder(
                  animation: _lineWidth,
                  builder: (_, __) => Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 80 * _lineWidth.value,
                      height: 2,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
