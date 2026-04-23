import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'hover_widget.dart';

class DsCard extends StatelessWidget {
  const DsCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.showAccentOnHover = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool showAccentOnHover;

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
      onTap: onTap,
      builder: (context, isHovered) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: padding ?? const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: isHovered && showAccentOnHover
                ? AppColors.surface
                : AppColors.surface.withOpacity(0.6),
            border: Border.all(
              color: isHovered && showAccentOnHover
                  ? AppColors.accent.withOpacity(0.4)
                  : AppColors.border.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        );
      },
    );
  }
}
