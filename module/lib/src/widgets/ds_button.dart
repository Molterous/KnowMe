import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import 'hover_widget.dart';

enum DsButtonVariant { primary, ghost, text }

class DsButton extends StatelessWidget {
  const DsButton({
    super.key,
    required this.label,
    this.onTap,
    this.variant = DsButtonVariant.primary,
    this.icon,
    this.trailing,
  });

  final String label;
  final VoidCallback? onTap;
  final DsButtonVariant variant;
  final Widget? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
      onTap: onTap,
      builder: (context, isHovered) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          decoration: _decoration(isHovered),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: AppSpacing.sm)],
              Text(label, style: _textStyle(isHovered)),
              if (trailing != null) ...[const SizedBox(width: AppSpacing.sm), trailing!],
            ],
          ),
        );
      },
    );
  }

  BoxDecoration _decoration(bool isHovered) => switch (variant) {
        DsButtonVariant.primary => BoxDecoration(
            color: isHovered ? AppColors.primaryText : AppColors.accent,
            borderRadius: BorderRadius.circular(4),
          ),
        DsButtonVariant.ghost => BoxDecoration(
            color: isHovered ? AppColors.surface : Colors.transparent,
            border: Border.all(color: AppColors.muted.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(4),
          ),
        DsButtonVariant.text => const BoxDecoration(),
      };

  TextStyle _textStyle(bool isHovered) => switch (variant) {
        DsButtonVariant.primary => AppTextStyles.titleMedium.copyWith(
            color: isHovered ? AppColors.background : AppColors.primaryText,
            fontWeight: FontWeight.w600,
          ),
        DsButtonVariant.ghost => AppTextStyles.titleMedium.copyWith(
            color: isHovered ? AppColors.primaryText : AppColors.muted,
          ),
        DsButtonVariant.text => AppTextStyles.titleMedium.copyWith(
            color: isHovered ? AppColors.accent : AppColors.muted,
          ),
      };
}
