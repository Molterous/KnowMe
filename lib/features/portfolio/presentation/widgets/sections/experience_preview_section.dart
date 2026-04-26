import 'package:flutter/material.dart';
import 'package:ds_core/ds_core.dart';
import '../../../domain/entities/portfolio_entity.dart';

class ExperiencePreviewSection extends StatelessWidget {
  const ExperiencePreviewSection({
    super.key,
    required this.experience,
    required this.onViewAll,
  });

  final List<ExperienceEntity> experience;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveBuilder(
          mobile: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(number: '02.', title: 'Experience'),
              SizedBox(height: AppSpacing.md),
            ],
          ),
          desktop: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SectionHeader(number: '02.', title: 'Experience'),
              DsButton(
                label: 'View Full Timeline →',
                variant: DsButtonVariant.text,
                onTap: onViewAll,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        StaggerAnimation(
          children: experience.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: _ExperiencePreviewCard(experience: e),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.xl),
        ResponsiveBuilder(
          mobile: DsButton(
            label: 'View Full Timeline →',
            variant: DsButtonVariant.ghost,
            onTap: onViewAll,
          ),
          desktop: const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _ExperiencePreviewCard extends StatelessWidget {
  const _ExperiencePreviewCard({required this.experience});
  final ExperienceEntity experience;

  @override
  Widget build(BuildContext context) {
    return TiltCard(
      child: ResponsiveBuilder(
        mobile: _CardMobile(experience: experience),
        desktop: _CardDesktop(experience: experience),
      ),
    );
  }
}

class _CardDesktop extends StatelessWidget {
  const _CardDesktop({required this.experience});
  final ExperienceEntity experience;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(experience.duration, style: AppTextStyles.labelLarge),
              if (experience.current) ...[
                const SizedBox(height: AppSpacing.sm),
                const MetricChip(label: 'Current'),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xl),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(experience.company, style: AppTextStyles.headlineLarge),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    '· ${experience.location}',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${experience.role} · ${experience.type}',
                style:
                    AppTextStyles.titleMedium.copyWith(color: AppColors.accent),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(experience.summary, style: AppTextStyles.bodyLarge),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children:
                    experience.metrics.map((m) => AnimatedMetricChip(label: m)).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardMobile extends StatelessWidget {
  const _CardMobile({required this.experience});
  final ExperienceEntity experience;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(experience.company, style: AppTextStyles.headlineMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${experience.role} · ${experience.type}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
            if (experience.current)
              const MetricChip(label: 'Current'),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(experience.duration, style: AppTextStyles.labelLarge),
        const SizedBox(height: AppSpacing.md),
        Text(experience.summary, style: AppTextStyles.bodyLarge),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: experience.metrics.map((m) => AnimatedMetricChip(label: m)).toList(),
        ),
      ],
    );
  }
}
