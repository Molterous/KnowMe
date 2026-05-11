import 'package:flutter/material.dart';
import 'package:ds_core/ds_core.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/core_strings.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeSlideTransition(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.notFound404,
                style: AppTextStyles.displayLarge.copyWith(
                  color: AppColors.accent,
                  fontSize: 120,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(AppStrings.notFoundTitle, style: AppTextStyles.headlineMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppStrings.notFoundSubtitle,
                style: AppTextStyles.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.xxl),
              DsButton(
                label: AppStrings.backHome,
                onTap: () => context.go(CoreStrings.routeHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
