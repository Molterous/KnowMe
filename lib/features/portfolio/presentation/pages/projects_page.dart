import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ds_core/ds_core.dart';
import 'package:go_router/go_router.dart';
import '../bloc/portfolio_bloc.dart';
import '../widgets/nav_bar.dart';
import '../widgets/portfolio_footer.dart';
import '../../domain/entities/portfolio_entity.dart';
import '../../../../../core/utils/app_strings.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<PortfolioBloc, PortfolioState>(
        builder: (context, state) {
          if (state.status != PortfolioStatus.success) {
            return const Center(child: CircularProgressIndicator());
          }
          final projects = state.data!.projects;
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
                          label: AppStrings.backToHome,
                          variant: DsButtonVariant.text,
                          onTap: () => context.go('/'),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        const SectionHeader(
                          number: AppStrings.sectionNumProjects,
                          title: AppStrings.sectionTitleAllProjects,
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        ResponsiveBuilder(
                          mobile: Column(
                            children: projects
                                .map((p) => Padding(
                                      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                                      child: _ProjectCard(project: p),
                                    ))
                                .toList(),
                          ),
                          desktop: _ProjectsGrid(projects: projects),
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

class _ProjectsGrid extends StatelessWidget {
  const _ProjectsGrid({required this.projects});
  final List projects;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.isTablet ? 2 : 3,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
        childAspectRatio: 0.9,
      ),
      itemCount: projects.length,
      itemBuilder: (_, i) => _ProjectCard(project: projects[i]),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});
  final ProjectEntity project;

  @override
  Widget build(BuildContext context) {
    return DsCard(
      onTap: () => context.go('/projects/${project.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(project.title, style: AppTextStyles.headlineMedium),
              ),
              if (project.status != ProjectStatus.completed)
                _buildStatusChip(project.status),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(project.subtitle, style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          Text(
            project.description,
            style: AppTextStyles.bodyLarge,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: (project.tech)
                .take(4)
                .map((t) => TagChip(label: t))
                .toList(),
          ),
        ],
      ),
    );
  }
}

Widget _buildStatusChip(ProjectStatus status) => switch (status) {
      ProjectStatus.inReview => const TagChip(label: AppStrings.statusInReview),
      ProjectStatus.githubRelease => const TagChip(label: AppStrings.statusGithubRelease),
      ProjectStatus.completed => const SizedBox.shrink(),
    };
