import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ds_core/ds_core.dart';
import 'package:go_router/go_router.dart';
import '../bloc/portfolio_bloc.dart';
import '../widgets/nav_bar.dart';
import '../widgets/portfolio_footer.dart';

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<PortfolioBloc, PortfolioState>(
        builder: (context, state) {
          if (state.status != PortfolioStatus.success) {
            return const Center(child: CircularProgressIndicator());
          }
          final project = state.data!.projects.firstWhere(
            (p) => p.id == id,
            orElse: () => state.data!.projects.first,
          );
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
                          label: '← Back to Projects',
                          variant: DsButtonVariant.text,
                          onTap: () => context.go('/projects'),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Row(
                          children: [
                            Expanded(
                              child: Text(project.title, style: AppTextStyles.displayMedium),
                            ),
                            if (project.status == 'in_review')
                              const TagChip(label: 'In Review'),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(project.subtitle,
                            style: AppTextStyles.titleLarge.copyWith(color: AppColors.accent)),
                        const SizedBox(height: AppSpacing.xxl),
                        Text('Overview', style: AppTextStyles.headlineMedium),
                        const SizedBox(height: AppSpacing.md),
                        Text(project.description, style: AppTextStyles.bodyLarge),
                        const SizedBox(height: AppSpacing.xxl),
                        const Divider(color: AppColors.divider),
                        const SizedBox(height: AppSpacing.xxl),
                        Text('Highlights', style: AppTextStyles.headlineMedium),
                        const SizedBox(height: AppSpacing.xl),
                        ...project.highlights.map<Widget>((h) => Padding(
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
                        const SizedBox(height: AppSpacing.xxl),
                        const Divider(color: AppColors.divider),
                        const SizedBox(height: AppSpacing.xxl),
                        Text('Impact', style: AppTextStyles.headlineMedium),
                        const SizedBox(height: AppSpacing.lg),
                        Wrap(
                          spacing: AppSpacing.md,
                          runSpacing: AppSpacing.md,
                          children: project.metrics
                              .map<Widget>((m) => AnimatedMetricChip(label: m))
                              .toList(),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        const Divider(color: AppColors.divider),
                        const SizedBox(height: AppSpacing.xxl),
                        Text('Tech Stack', style: AppTextStyles.headlineMedium),
                        const SizedBox(height: AppSpacing.lg),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: project.tech
                              .map<Widget>((t) => TagChip(label: t))
                              .toList(),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: (project.platform)
                              .map((p) => TagChip(label: p))
                              .toList(),
                        ),
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
