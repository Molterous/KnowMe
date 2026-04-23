import 'package:flutter/material.dart';
import 'package:ds_core/ds_core.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = context.responsive<double>(
      mobile: AppSpacing.lg,
      desktop: AppSpacing.xxxl,
    );

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: AppSpacing.xxl), // ignore: prefer_const_constructors
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroShimmer(),
          SizedBox(height: AppSpacing.section),
          SectionShimmer(cardCount: 2, cardShimmer: ExperienceCardShimmer()),
          SizedBox(height: AppSpacing.section),
          SectionShimmer(cardCount: 3, cardShimmer: ProjectCardShimmer()),
        ],
      ),
    );
  }
}
