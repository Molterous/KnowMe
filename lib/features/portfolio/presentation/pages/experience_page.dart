import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ds_core/ds_core.dart';
import 'package:go_router/go_router.dart';
import '../bloc/portfolio_bloc.dart';
import '../widgets/nav_bar.dart';
import '../widgets/portfolio_footer.dart';
import '../../domain/entities/portfolio_entity.dart';

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<PortfolioBloc, PortfolioState>(
        builder: (context, state) {
          if (state.status != PortfolioStatus.success) {
            return const Center(child: CircularProgressIndicator());
          }
          final experience = state.data!.experience;
          return Column(
            children: [
              PortfolioNavBar(onSectionTap: (_) => context.go('/')),
              Expanded(
                child: SingleChildScrollView(
                  child: MaxWidthBox(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.responsive<double>(
                        mobile: AppSpacing.lg,
                        desktop: AppSpacing.xxxl,
                      ),
                      vertical: AppSpacing.xxl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DsButton(
                          label: '← Back to Home',
                          variant: DsButtonVariant.text,
                          onTap: () => context.go('/'),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        const SectionHeader(number: '02.', title: 'Experience'),
                        const SizedBox(height: AppSpacing.xxl),
                        _TimelineList(experience: experience),
                        const PortfolioFooter(),
                      ],
                    ),
                  ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TimelineList extends StatelessWidget {
  const _TimelineList({required this.experience});
  final List<ExperienceEntity> experience;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(experience.length, (i) {
        final isLast = i == experience.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                child: Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(top: AppSpacing.lg + 4),
                      decoration: BoxDecoration(
                        color: experience[i].current
                            ? AppColors.accent
                            : AppColors.surface,
                        border: Border.all(color: AppColors.accent, width: 2),
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: AppColors.accent.withOpacity(0.25),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                  child: _ExperienceCard(experience: experience[i]),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.experience});
  final ExperienceEntity experience;

  @override
  Widget build(BuildContext context) {
    return DsCard(
      showAccentOnHover: false,
      child: Column(
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
                    Text(experience.company, style: AppTextStyles.displaySmall),
                    const SizedBox(height: AppSpacing.xs),
                    Text('${experience.role} · ${experience.type}',
                        style: AppTextStyles.titleLarge.copyWith(color: AppColors.accent)),
                    const SizedBox(height: AppSpacing.xs),
                    Text(experience.location, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(experience.duration, style: AppTextStyles.labelLarge),
                  if (experience.current)
                    const Padding(
                      padding: EdgeInsets.only(top: AppSpacing.xs),
                      child: MetricChip(label: 'Current'),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const Divider(color: AppColors.divider),
          const SizedBox(height: AppSpacing.xl),
          ...experience.highlights.map<Widget>((h) => Padding(
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
          const SizedBox(height: AppSpacing.xl),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: experience.tech.map<Widget>((t) => TagChip(label: t)).toList(),
          ),
        ],
      ),
    );
  }
}
