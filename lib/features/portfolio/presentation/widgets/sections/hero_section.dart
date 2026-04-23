import 'package:flutter/material.dart';
import 'package:ds_core/ds_core.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../domain/entities/portfolio_entity.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.personal, this.onViewWork});
  final PersonalEntity personal;
  final VoidCallback? onViewWork;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: _HeroMobile(personal: personal, onViewWork: onViewWork),
      tablet: _HeroTablet(personal: personal, onViewWork: onViewWork),
      desktop: _HeroDesktop(personal: personal, onViewWork: onViewWork),
    );
  }
}

// ── Desktop ───────────────────────────────────────────────────────────────────

class _HeroDesktop extends StatelessWidget {
  const _HeroDesktop({required this.personal, this.onViewWork});
  final PersonalEntity personal;
  final VoidCallback? onViewWork;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.92,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 6,
                child: FadeSlideTransition(
                  child: _HeroText(personal: personal, onViewWork: onViewWork),
                ),
              ),
              const SizedBox(width: AppSpacing.xxl),
              const Expanded(
                flex: 4,
                child: FadeSlideTransition(
                  delay: Duration(milliseconds: 200),
                  offset: Offset(24, 0),
                  child: _HeroPhoto(),
                ),
              ),
            ],
          ),
          const Positioned(
            bottom: AppSpacing.xl,
            left: 0,
            right: 0,
            child: Center(child: ScrollIndicator()),
          ),
        ],
      ),
    );
  }
}

// ── Tablet ────────────────────────────────────────────────────────────────────

class _HeroTablet extends StatelessWidget {
  const _HeroTablet({required this.personal, this.onViewWork});
  final PersonalEntity personal;
  final VoidCallback? onViewWork;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.section),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 7,
            child: FadeSlideTransition(
              child: _HeroText(personal: personal, onViewWork: onViewWork),
            ),
          ),
          const SizedBox(width: AppSpacing.xl),
          const Expanded(
            flex: 3,
            child: FadeSlideTransition(
              delay: Duration(milliseconds: 200),
              offset: Offset(24, 0),
              child: _HeroPhoto(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mobile ────────────────────────────────────────────────────────────────────

class _HeroMobile extends StatelessWidget {
  const _HeroMobile({required this.personal, this.onViewWork});
  final PersonalEntity personal;
  final VoidCallback? onViewWork;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: FadeSlideTransition(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: _HeroPhoto(size: 120)),
            const SizedBox(height: AppSpacing.xl),
            _HeroText(personal: personal, onViewWork: onViewWork),
          ],
        ),
      ),
    );
  }
}

// ── Shared pieces ─────────────────────────────────────────────────────────────

class _HeroText extends StatelessWidget {
  const _HeroText({required this.personal, this.onViewWork});
  final PersonalEntity personal;
  final VoidCallback? onViewWork;

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (personal.available) ...[
          _AvailableBadge(),
          const SizedBox(height: AppSpacing.xl),
        ],
        Text(
          personal.name,
          style: isDesktop
              ? AppTextStyles.displayLarge
              : AppTextStyles.displayMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          personal.subtitle,
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.muted,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(personal.tagline, style: AppTextStyles.bodyLarge),
        const SizedBox(height: AppSpacing.xxl),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            DsButton(
              label: 'View Work',
              onTap: onViewWork,
            ),
            DsButton(
              label: 'Say Hi →',
              variant: DsButtonVariant.ghost,
              onTap: () async {
                final uri = Uri.parse('mailto:${personal.email}');
                if (await canLaunchUrl(uri)) launchUrl(uri);
              },
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.muted,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(personal.location, style: AppTextStyles.labelLarge),
          ],
        ),
      ],
    );
  }
}

class _AvailableBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        border: Border.all(color: AppColors.accent.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Available for work',
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}

class _HeroPhoto extends StatelessWidget {
  const _HeroPhoto({this.size});
  final double? size;

  @override
  Widget build(BuildContext context) {
    final dimension = size ?? (context.isTablet ? 220.0 : 320.0);
    return Center(
      child: Container(
        width: dimension,
        height: dimension,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          'assets/images/self.jpg',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Center(
            child: Text(
              'AC',
              style: AppTextStyles.displaySmall.copyWith(color: AppColors.accent),
            ),
          ),
        ),
      ),
    );
  }
}
