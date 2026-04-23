import 'package:flutter/material.dart';
import 'package:ds_core/ds_core.dart';
import '../../../domain/entities/portfolio_entity.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key, required this.skills});
  final SkillsEntity skills;

  @override
  Widget build(BuildContext context) {
    final groups = [
      _SkillGroup(label: 'Languages', items: skills.languages),
      _SkillGroup(label: 'Frameworks & Platforms', items: skills.frameworks),
      _SkillGroup(label: 'Architecture & Patterns', items: skills.architecture),
      _SkillGroup(label: 'Cloud & DevOps', items: skills.cloud),
      _SkillGroup(label: 'Tools', items: skills.tools),
      _SkillGroup(label: 'Domain Expertise', items: skills.expertise),
    ];

    return FadeSlideTransition(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(number: '04.', title: 'Skills'),
          const SizedBox(height: AppSpacing.xxl),
          ResponsiveBuilder(
            mobile: _SkillsMobile(groups: groups),
            tablet: _SkillsGrid(groups: groups, columns: 2),
            desktop: _SkillsGrid(groups: groups, columns: 3),
          ),
        ],
      ),
    );
  }
}

class _SkillsGrid extends StatelessWidget {
  const _SkillsGrid({required this.groups, required this.columns});
  final List<_SkillGroup> groups;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (int i = 0; i < groups.length; i += columns) {
      final rowItems = groups.sublist(i, (i + columns).clamp(0, groups.length));
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowItems.map((g) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: g != rowItems.last ? AppSpacing.xl : 0,
                ),
                child: _SkillGroupWidget(group: g),
              ),
            )).toList(),
          ),
        ),
      );
      if (i + columns < groups.length) {
        rows.add(const SizedBox(height: AppSpacing.xl));
      }
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }
}

class _SkillsMobile extends StatelessWidget {
  const _SkillsMobile({required this.groups});
  final List<_SkillGroup> groups;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groups.map((g) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
        child: _SkillGroupWidget(group: g),
      )).toList(),
    );
  }
}

class _SkillGroupWidget extends StatelessWidget {
  const _SkillGroupWidget({required this.group});
  final _SkillGroup group;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group.label.toUpperCase(),
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.accent,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: group.items.map((i) => TagChip(label: i)).toList(),
        ),
      ],
    );
  }
}

class _SkillGroup {
  const _SkillGroup({required this.label, required this.items});
  final String label;
  final List<String> items;
}
