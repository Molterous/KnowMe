import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ds_core/ds_core.dart';
import 'package:go_router/go_router.dart';
import '../bloc/portfolio_bloc.dart';
import '../widgets/nav_bar.dart';
import '../widgets/portfolio_footer.dart';
import '../widgets/project_widgets.dart';
import '../../domain/entities/portfolio_entity.dart';
import '../../../../../core/utils/app_strings.dart';

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
                            label: AppStrings.backToProjects,
                            variant: DsButtonVariant.text,
                            onTap: () => context.go('/projects'),
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // ── Title block ──────────────────────────────────
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  project.title,
                                  style: AppTextStyles.displayMedium,
                                ),
                              ),
                              if (project.status != ProjectStatus.completed)
                                _buildStatusChip(project.status),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            project.subtitle,
                            style: AppTextStyles.titleLarge
                                .copyWith(color: AppColors.accent),
                          ),
                          if (project.links.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.lg),
                            ProjectLinksRow(links: project.links),
                          ],

                          // ── Screenshot carousel ──────────────────────────
                          if (project.images.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.xxl),
                            Text(
                              AppStrings.labelScreenshots,
                              style: AppTextStyles.headlineMedium,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            ProjectImageCarousel(
                              images: project.images,
                              height: context.responsive<double>(
                                mobile: 200,
                                desktop: 300,
                              ),
                            ),
                          ],

                          const SizedBox(height: AppSpacing.xxl),
                          const Divider(color: AppColors.divider),
                          const SizedBox(height: AppSpacing.xxl),

                          // ── Overview ─────────────────────────────────────
                          Text(AppStrings.labelOverview, style: AppTextStyles.headlineMedium),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            project.description,
                            style: AppTextStyles.bodyLarge,
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          const Divider(color: AppColors.divider),
                          const SizedBox(height: AppSpacing.xxl),

                          // ── Highlights ───────────────────────────────────
                          Text(AppStrings.labelHighlights, style: AppTextStyles.headlineMedium),
                          const SizedBox(height: AppSpacing.xl),
                          ...project.highlights.map<Widget>(
                            (h) => Padding(
                              padding:
                                  const EdgeInsets.only(bottom: AppSpacing.md),
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
                                  Expanded(
                                    child: Text(
                                      h,
                                      style: AppTextStyles.bodyLarge,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          const Divider(color: AppColors.divider),
                          const SizedBox(height: AppSpacing.xxl),

                          // ── Impact ───────────────────────────────────────
                          Text(AppStrings.labelImpact, style: AppTextStyles.headlineMedium),
                          const SizedBox(height: AppSpacing.lg),
                          Wrap(
                            spacing: AppSpacing.md,
                            runSpacing: AppSpacing.md,
                            children: project.metrics
                                .map<Widget>(
                                  (m) => AnimatedMetricChip(label: m),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          const Divider(color: AppColors.divider),
                          const SizedBox(height: AppSpacing.xxl),

                          // ── Tech Stack ───────────────────────────────────
                          Text(AppStrings.labelTechStack, style: AppTextStyles.headlineMedium),
                          const SizedBox(height: AppSpacing.lg),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: project.tech
                                .map<Widget>((t) => TagChip(label: t))
                                .toList(),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: project.platform
                                .map<Widget>((p) => TagChip(label: p))
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

Widget _buildStatusChip(ProjectStatus status) => switch (status) {
      ProjectStatus.inReview => const TagChip(label: AppStrings.statusInReview),
      ProjectStatus.githubRelease => const TagChip(label: AppStrings.statusGithubRelease),
      ProjectStatus.completed => const SizedBox.shrink(),
    };
