import 'package:flutter/material.dart';
import 'package:ds_core/ds_core.dart';
import '../../../domain/entities/portfolio_entity.dart';

class ProjectsPreviewSection extends StatelessWidget {
  const ProjectsPreviewSection({
    super.key,
    required this.projects,
  });

  final List<ProjectEntity> projects;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(number: '03.', title: 'Selected Work'),
        const SizedBox(height: AppSpacing.xxl),
        ResponsiveBuilder(
          mobile: _ProjectsColumn(projects: projects),
          tablet: _ProjectsGrid(projects: projects, columns: 2),
          desktop: _ProjectsGrid(projects: projects, columns: 3),
        )
      ],
    );
  }
}

class _ProjectsGrid extends StatefulWidget {
  const _ProjectsGrid({required this.projects, required this.columns});

  final List<ProjectEntity> projects;
  final int columns;

  @override
  State<_ProjectsGrid> createState() => _ProjectsGridState();
}

class _ProjectsGridState extends State<_ProjectsGrid> {
  late List<List<ProjectEntity>> _rows;

  @override
  void initState() {
    super.initState();
    _buildRows();
  }

  @override
  void didUpdateWidget(_ProjectsGrid old) {
    super.didUpdateWidget(old);
    if (old.projects != widget.projects || old.columns != widget.columns) {
      _buildRows();
    }
  }

  void _buildRows() {
    _rows = [];
    for (int i = 0; i < widget.projects.length; i += widget.columns) {
      _rows.add(widget.projects.sublist(
        i,
        (i + widget.columns).clamp(0, widget.projects.length),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_rows.length, (ri) {
        final row = _rows[ri];
        final isLast = ri == _rows.length - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < row.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.lg),
                Expanded(child: _ProjectCard(project: row[i], fixedLayout: true)),
              ],
              for (int i = row.length; i < widget.columns; i++) ...[
                const SizedBox(width: AppSpacing.lg),
                const Expanded(child: SizedBox()),
              ],
            ],
          ),
        );
      }),
    );
  }
}

class _ProjectsColumn extends StatelessWidget {
  const _ProjectsColumn({required this.projects});
  final List<ProjectEntity> projects;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: projects.map((p) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: _ProjectCard(project: p),
      )).toList(),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, this.fixedLayout = false});
  final ProjectEntity project;
  final bool fixedLayout;

  Widget _constrain(double minHeight, Widget child) => fixedLayout
      ? ConstrainedBox(
          constraints: BoxConstraints(minHeight: minHeight),
          child: child,
        )
      : child;

  @override
  Widget build(BuildContext context) {
    return TiltCard(
      onTap: () => showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.75),
        builder: (_) => _ProjectDetailDialog(project: project),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _constrain(
            56,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    project.title,
                    style: AppTextStyles.headlineMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (project.status == 'in_review')
                  const TagChip(label: 'In Review'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _constrain(
            46,
            Text(
              project.subtitle,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accent),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _constrain(
            90,
            Text(
              project.description,
              style: AppTextStyles.bodyMedium,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _constrain(
            56,
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: project.tech
                  .take(3)
                  .map((t) => TagChip(label: t))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Full-screen detail dialog ─────────────────────────────────────────────────

class _ProjectDetailDialog extends StatelessWidget {
  const _ProjectDetailDialog({required this.project});
  final ProjectEntity project;

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
            _ProjectDialogHeader(project: project),
            const Divider(color: AppColors.divider, height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Overview', style: AppTextStyles.headlineMedium),
                    const SizedBox(height: AppSpacing.md),
                    Text(project.description, style: AppTextStyles.bodyLarge),
                    const SizedBox(height: AppSpacing.xxl),
                    const Divider(color: AppColors.divider),
                    const SizedBox(height: AppSpacing.xl),
                    Text('Highlights', style: AppTextStyles.headlineMedium),
                    const SizedBox(height: AppSpacing.lg),
                    ...project.highlights.map((h) => Padding(
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
                    if (project.metrics.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xl),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: AppSpacing.xl),
                      Text('Impact', style: AppTextStyles.headlineMedium),
                      const SizedBox(height: AppSpacing.lg),
                      Wrap(
                        spacing: AppSpacing.md,
                        runSpacing: AppSpacing.md,
                        children: project.metrics
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
                      children: project.tech.map((t) => TagChip(label: t)).toList(),
                    ),
                    if (project.platform.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: project.platform.map((p) => TagChip(label: p)).toList(),
                      ),
                    ],
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

class _ProjectDialogHeader extends StatelessWidget {
  const _ProjectDialogHeader({required this.project});
  final ProjectEntity project;

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
                Row(
                  children: [
                    Expanded(
                      child: Text(project.title, style: AppTextStyles.displaySmall),
                    ),
                    if (project.status == 'in_review')
                      const TagChip(label: 'In Review'),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  project.subtitle,
                  style: AppTextStyles.titleLarge.copyWith(color: AppColors.accent),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
