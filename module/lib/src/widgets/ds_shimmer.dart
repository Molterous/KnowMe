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
              children: [
                ShimmerBlock(width: 100, height: 20),
                Spacer(),
                ShimmerBlock(width: 60, height: 14),
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

// About section skeleton
class AboutSectionShimmer extends StatelessWidget {
  const AboutSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return DsShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          const ShimmerBlock(width: 60, height: 13),
          const SizedBox(height: AppSpacing.sm),
          const ShimmerBlock(width: 160, height: 36),
          const SizedBox(height: AppSpacing.lg),
          const ShimmerBlock(width: 48, height: 2),
          const SizedBox(height: AppSpacing.xxl),
          // Bio lines
          const ShimmerBlock(height: 16),
          const SizedBox(height: AppSpacing.sm),
          const ShimmerBlock(height: 16),
          const SizedBox(height: AppSpacing.sm),
          const ShimmerBlock(width: 280, height: 16),
          const SizedBox(height: AppSpacing.xxl),
          // Highlight chips
          const Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              ShimmerBlock(width: 110, height: 40, borderRadius: 6),
              ShimmerBlock(width: 140, height: 40, borderRadius: 6),
              ShimmerBlock(width: 120, height: 40, borderRadius: 6),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          // Education card
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBlock(width: 3, height: 60, borderRadius: 2),
                SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBlock(width: 220, height: 16),
                      SizedBox(height: AppSpacing.xs),
                      ShimmerBlock(width: 180, height: 14),
                      SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          ShimmerBlock(width: 80, height: 26, borderRadius: 4),
                          SizedBox(width: AppSpacing.sm),
                          ShimmerBlock(width: 60, height: 26, borderRadius: 4),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          // Personality chips
          const ShimmerBlock(width: 200, height: 13),
          const SizedBox(height: AppSpacing.md),
          const Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              ShimmerBlock(width: 100, height: 30, borderRadius: 4),
              ShimmerBlock(width: 80, height: 30, borderRadius: 4),
              ShimmerBlock(width: 120, height: 30, borderRadius: 4),
              ShimmerBlock(width: 90, height: 30, borderRadius: 4),
            ],
          ),
        ],
      ),
    );
  }
}

// Skills section skeleton
class SkillsSectionShimmer extends StatelessWidget {
  const SkillsSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return DsShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          const ShimmerBlock(width: 60, height: 13),
          const SizedBox(height: AppSpacing.sm),
          const ShimmerBlock(width: 140, height: 36),
          const SizedBox(height: AppSpacing.lg),
          const ShimmerBlock(width: 48, height: 2),
          const SizedBox(height: AppSpacing.xxl),
          // Two rows of 3 skill groups
          for (int row = 0; row < 2; row++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(3, (col) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: col < 2 ? AppSpacing.xl : 0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBlock(width: 100, height: 12),
                      SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          ShimmerBlock(width: 60, height: 28, borderRadius: 4),
                          ShimmerBlock(width: 80, height: 28, borderRadius: 4),
                          ShimmerBlock(width: 50, height: 28, borderRadius: 4),
                          ShimmerBlock(width: 70, height: 28, borderRadius: 4),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
            ),
            if (row == 0) const SizedBox(height: AppSpacing.xl),
          ],
        ],
      ),
    );
  }
}

// Contact section skeleton
class ContactSectionShimmer extends StatelessWidget {
  const ContactSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const DsShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header (two-line title)
          ShimmerBlock(width: 60, height: 13),
          SizedBox(height: AppSpacing.sm),
          ShimmerBlock(width: 300, height: 36),
          SizedBox(height: AppSpacing.sm),
          ShimmerBlock(width: 220, height: 36),
          SizedBox(height: AppSpacing.lg),
          ShimmerBlock(width: 48, height: 2),
          SizedBox(height: AppSpacing.xxl),
          // Email
          ShimmerBlock(width: 340, height: 32),
          SizedBox(height: AppSpacing.xl),
          // Social link buttons
          Row(
            children: [
              ShimmerBlock(width: 100, height: 40, borderRadius: 4),
              SizedBox(width: AppSpacing.md),
              ShimmerBlock(width: 100, height: 40, borderRadius: 4),
              SizedBox(width: AppSpacing.md),
              ShimmerBlock(width: 100, height: 40, borderRadius: 4),
            ],
          ),
        ],
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
