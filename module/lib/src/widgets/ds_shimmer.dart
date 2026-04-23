import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class DsShimmer extends StatelessWidget {
  const DsShimmer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.muted.withOpacity(0.15),
      child: child,
    );
  }
}

class ShimmerBlock extends StatelessWidget {
  const ShimmerBlock({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 4,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

// Hero section skeleton
class HeroShimmer extends StatelessWidget {
  const HeroShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const DsShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBlock(width: 120, height: 13),
          SizedBox(height: AppSpacing.lg),
          ShimmerBlock(width: 480, height: 72),
          SizedBox(height: AppSpacing.sm),
          ShimmerBlock(width: 360, height: 72),
          SizedBox(height: AppSpacing.xl),
          ShimmerBlock(width: 300, height: 18),
          SizedBox(height: AppSpacing.xxl),
          Row(
            children: [
              ShimmerBlock(width: 140, height: 48, borderRadius: 4),
              SizedBox(width: AppSpacing.md),
              ShimmerBlock(width: 140, height: 48, borderRadius: 4),
            ],
          ),
        ],
      ),
    );
  }
}

// Experience card skeleton
class ExperienceCardShimmer extends StatelessWidget {
  const ExperienceCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return DsShimmer(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBlock(width: 160, height: 20),
                ShimmerBlock(width: 100, height: 14),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            ShimmerBlock(width: 120, height: 14),
            SizedBox(height: AppSpacing.md),
            ShimmerBlock(height: 14),
            SizedBox(height: AppSpacing.sm),
            ShimmerBlock(width: 260, height: 14),
            SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                ShimmerBlock(width: 80, height: 28, borderRadius: 4),
                SizedBox(width: AppSpacing.sm),
                ShimmerBlock(width: 100, height: 28, borderRadius: 4),
                SizedBox(width: AppSpacing.sm),
                ShimmerBlock(width: 90, height: 28, borderRadius: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Project card skeleton
class ProjectCardShimmer extends StatelessWidget {
  const ProjectCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return DsShimmer(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBlock(width: 200, height: 22),
            SizedBox(height: AppSpacing.sm),
            ShimmerBlock(width: 160, height: 14),
            SizedBox(height: AppSpacing.md),
            ShimmerBlock(height: 14),
            SizedBox(height: AppSpacing.xs),
            ShimmerBlock(width: 280, height: 14),
            SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                ShimmerBlock(width: 70, height: 26, borderRadius: 4),
                SizedBox(width: AppSpacing.sm),
                ShimmerBlock(width: 60, height: 26, borderRadius: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Generic section skeleton (section header + n cards)
class SectionShimmer extends StatelessWidget {
  const SectionShimmer({super.key, this.cardCount = 2, this.cardShimmer});

  final int cardCount;
  final Widget? cardShimmer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DsShimmer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBlock(width: 80, height: 13),
              SizedBox(height: AppSpacing.sm),
              ShimmerBlock(width: 220, height: 36),
              SizedBox(height: AppSpacing.lg),
              ShimmerBlock(width: 48, height: 2),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        for (int i = 0; i < cardCount; i++) ...[
          cardShimmer ?? const ExperienceCardShimmer(),
          if (i < cardCount - 1) const SizedBox(height: AppSpacing.lg),
        ],
      ],
    );
  }
}
