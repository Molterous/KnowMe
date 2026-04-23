import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.number,
    required this.title,
    this.subtitle,
  });

  final String number;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(number, style: AppTextStyles.sectionNumber),
        const SizedBox(height: AppSpacing.sm),
        Text(title, style: AppTextStyles.displaySmall),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(subtitle!, style: AppTextStyles.bodyLarge),
        ],
        const SizedBox(height: AppSpacing.lg),
        Container(
          width: 48,
          height: 2,
          color: AppColors.accent,
        ),
      ],
    );
  }
}
