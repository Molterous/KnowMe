import 'package:flutter/material.dart';
import 'package:ds_core/ds_core.dart';
import '../../../domain/entities/portfolio_entity.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key, required this.about, required this.education});
  final AboutEntity about;
  final EducationEntity education;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: _AboutMobile(about: about, education: education),
      desktop: _AboutDesktop(about: about, education: education),
    );
  }
}

class _AboutDesktop extends StatelessWidget {
  const _AboutDesktop({required this.about, required this.education});
  final AboutEntity about;
  final EducationEntity education;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          flex: 4,
          child: SectionHeader(number: '01.', title: 'About'),
        ),
        Expanded(
          flex: 6,
          child: FadeSlideTransition(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(about.bio, style: AppTextStyles.bodyLarge),
                const SizedBox(height: AppSpacing.xxl),
                _HighlightsRow(highlights: about.highlights),
                const SizedBox(height: AppSpacing.xxl),
                _EducationCard(education: education),
                const SizedBox(height: AppSpacing.xxl),
                _PersonalityChips(chips: about.personalityChips),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AboutMobile extends StatelessWidget {
  const _AboutMobile({required this.about, required this.education});
  final AboutEntity about;
  final EducationEntity education;

  @override
  Widget build(BuildContext context) {
    return FadeSlideTransition(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(number: '01.', title: 'About'),
          const SizedBox(height: AppSpacing.xxl),
          Text(about.bio, style: AppTextStyles.bodyLarge),
          const SizedBox(height: AppSpacing.xl),
          _HighlightsRow(highlights: about.highlights),
          const SizedBox(height: AppSpacing.xl),
          _EducationCard(education: education),
          const SizedBox(height: AppSpacing.xl),
          _PersonalityChips(chips: about.personalityChips),
        ],
      ),
    );
  }
}

class _HighlightsRow extends StatelessWidget {
  const _HighlightsRow({required this.highlights});
  final List<String> highlights;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: highlights.map((h) => _HighlightItem(text: h)).toList(),
    );
  }
}

class _HighlightItem extends StatelessWidget {
  const _HighlightItem({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Text(text, style: AppTextStyles.titleMedium),
    );
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard({required this.education});
  final EducationEntity education;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(education.degree, style: AppTextStyles.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(education.institution, style: AppTextStyles.bodyMedium),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    MetricChip(label: 'CGPA ${education.cgpa}'),
                    const SizedBox(width: AppSpacing.sm),
                    TagChip(label: education.year),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonalityChips extends StatelessWidget {
  const _PersonalityChips({required this.chips});
  final List<String> chips;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'The person behind the code',
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.accent,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: chips.map((c) => TagChip(label: '"$c"')).toList(),
        ),
      ],
    );
  }
}
