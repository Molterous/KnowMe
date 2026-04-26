import 'package:flutter/material.dart';
import 'package:ds_core/ds_core.dart';
import '../../../domain/entities/portfolio_entity.dart';

class ProjectsPreviewSection extends StatelessWidget {
  const ProjectsPreviewSection({
    super.key,
    required this.projects,
    required this.onViewAll,
    required this.onProjectTap,
  });

  final List<ProjectEntity> projects;
  final VoidCallback onViewAll;
  final void Function(String id) onProjectTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveBuilder(
          mobile: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(number: '03.', title: 'Selected Work'),
              SizedBox(height: AppSpacing.md),
            ],
          ),
          desktop: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SectionHeader(number: '03.', title: 'Selected Work'),
              DsButton(
                label: 'View All Projects →',
                variant: DsButtonVariant.text,
                onTap: onViewAll,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        ResponsiveBuilder(
          mobile: _ProjectsColumn(
              projects: projects, onProjectTap: onProjectTap),
          tablet: _ProjectsGrid(
              projects: projects, columns: 2, onProjectTap: onProjectTap),
          desktop: _ProjectsGrid(
              projects: projects, columns: 3, onProjectTap: onProjectTap),
        ),
        const SizedBox(height: AppSpacing.xl),
        ResponsiveBuilder(
          mobile: DsButton(
            label: 'View All Projects →',
            variant: DsButtonVariant.ghost,
            onTap: onViewAll,
          ),
          desktop: const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _ProjectsGrid extends StatelessWidget {
  const _ProjectsGrid({
    required this.projects,
    required this.columns,
    required this.onProjectTap,
  });

  final List<ProjectEntity> projects;
  final int columns;
  final void Function(String) onProjectTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
        childAspectRatio: 1.05,
      ),
      itemCount: projects.length,
      itemBuilder: (_, i) => _ProjectCard(
        project: projects[i],
        onTap: () => onProjectTap(projects[i].id),
      ),
    );
  }
}

class _ProjectsColumn extends StatelessWidget {
  const _ProjectsColumn({required this.projects, required this.onProjectTap});
  final List<ProjectEntity> projects;
  final void Function(String) onProjectTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: projects.map((p) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: _ProjectCard(project: p, onTap: () => onProjectTap(p.id)),
      )).toList(),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, required this.onTap});
  final ProjectEntity project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TiltCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(project.title, style: AppTextStyles.headlineMedium),
              ),
              if (project.status == 'in_review')
                const TagChip(label: 'In Review'),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            project.subtitle,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accent),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            project.description,
            style: AppTextStyles.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: project.tech
                .take(4)
                .map((t) => TagChip(label: t))
                .toList(),
          ),
        ],
      ),
    );
  }
}
