import 'package:flutter/material.dart';
import 'package:ds_core/ds_core.dart';
import '../../../../../core/utils/app_strings.dart';

class PortfolioFooter extends StatelessWidget {
  const PortfolioFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: AppSpacing.section),
      child: Column(
        children: [
          Divider(color: AppColors.divider),
          SizedBox(height: AppSpacing.xl),
          ResponsiveBuilder(
            mobile: _FooterMobile(),
            desktop: _FooterDesktop(),
          ),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _FooterDesktop extends StatelessWidget {
  const _FooterDesktop();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(AppStrings.footerName, style: AppTextStyles.titleMedium),
        Text(
          '© ${DateTime.now().year} · ${AppStrings.footerBuiltBy}',
          style: AppTextStyles.labelLarge,
        ),
        Text(AppStrings.footerLocation, style: AppTextStyles.labelLarge),
      ],
    );
  }
}

class _FooterMobile extends StatelessWidget {
  const _FooterMobile();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppStrings.footerName, style: AppTextStyles.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '© ${DateTime.now().year} · ${AppStrings.footerLocation}',
          style: AppTextStyles.labelLarge,
        ),
      ],
    );
  }
}
