import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import 'hover_widget.dart';

/// Replacement for [TagChip] that lifts slightly and gains an accent border
/// + soft glow on hover. Used in skills section.
class GlowChip extends StatelessWidget {
  const GlowChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
      builder: (context, hovered) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..translate(0.0, hovered ? -2.0 : 0.0),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs + 2,
          ),
          decoration: BoxDecoration(
            color: hovered
                ? AppColors.accent.withOpacity(0.08)
                : AppColors.surface,
            border: Border.all(
              color: hovered
                  ? AppColors.accent.withOpacity(0.5)
                  : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(4),
            boxShadow: hovered
                ? [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.18),
                      blurRadius: 18,
                      spreadRadius: -4,
                    ),
                  ]
                : const [],
          ),
          child: Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(
              color: hovered ? AppColors.primaryText : AppColors.muted,
            ),
          ),
        );
      },
    );
  }
}
