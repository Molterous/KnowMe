import 'package:flutter/material.dart';
import 'package:ds_core/ds_core.dart';
import '../../../domain/entities/portfolio_entity.dart';

class ExperiencePreviewSection extends StatelessWidget {
  const ExperiencePreviewSection({
    super.key,
    required this.experience,
  });

  final List<ExperienceEntity> experience;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(number: '02.', title: 'Experience'),
        const SizedBox(height: AppSpacing.xxl),
        StaggerAnimation(
          children: experience.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: _ExperiencePreviewCard(experience: e),
            );
          }).toList(),
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
      onTap: () => showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.75),
        builder: (_) => _ExperienceDetailDialog(experience: experience),
      ),
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

// ── Full-screen detail dialog ─────────────────────────────────────────────────

class _ExperienceDetailDialog extends StatelessWidget {
  const _ExperienceDetailDialog({required this.experience});
  final ExperienceEntity experience;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isNarrow = size.width < 600;

    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: isNarrow
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 64, vertical: 48),
      shape: isNarrow
          ? const RoundedRectangleBorder()
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: double.infinity,
        height: isNarrow ? size.height : size.height * 0.85,
        child: Column(
          children: [
            _DialogHeader(
              title: experience.company,
              subtitle: '${experience.role} · ${experience.type}',
            ),
            const Divider(color: AppColors.divider, height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(experience.duration, style: AppTextStyles.labelLarge),
                        const SizedBox(width: AppSpacing.md),
                        Text('· ${experience.location}', style: AppTextStyles.bodyMedium),
                        if (experience.current) ...[
                          const SizedBox(width: AppSpacing.md),
                          const MetricChip(label: 'Current'),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(experience.summary, style: AppTextStyles.bodyLarge),
                    const SizedBox(height: AppSpacing.xxl),
                    const Divider(color: AppColors.divider),
                    const SizedBox(height: AppSpacing.xl),
                    Text('Highlights', style: AppTextStyles.headlineMedium),
                    const SizedBox(height: AppSpacing.lg),
                    ...experience.highlights.map((h) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 7),
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(child: Text(h, style: AppTextStyles.bodyLarge)),
                        ],
                      ),
                    )),
                    if (experience.metrics.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xl),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: AppSpacing.xl),
                      Text('Impact', style: AppTextStyles.headlineMedium),
                      const SizedBox(height: AppSpacing.lg),
                      Wrap(
                        spacing: AppSpacing.md,
                        runSpacing: AppSpacing.md,
                        children: experience.metrics
                            .map((m) => AnimatedMetricChip(label: m))
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    const Divider(color: AppColors.divider),
                    const SizedBox(height: AppSpacing.xl),
                    Text('Tech Stack', style: AppTextStyles.headlineMedium),
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: experience.tech.map((t) => TagChip(label: t)).toList(),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.md, AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.displaySmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: AppTextStyles.titleLarge.copyWith(color: AppColors.accent),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
