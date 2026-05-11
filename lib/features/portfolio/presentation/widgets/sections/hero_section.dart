// ignore: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ds_core/ds_core.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/core_strings.dart';
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
        clipBehavior: Clip.none,
        children: [
          // Slow-breathing accent orb behind everything
          const Positioned(
            right: -60,
            top: 40,
            child: IgnorePointer(
              child: AnimatedGradientOrb(size: 520, opacity: 0.18),
            ),
          ),
          // Sphere — right two-thirds of the hero
          const Positioned.fill(
            child: Row(
              children: [
                Spacer(),
                Expanded(
                  flex: 2,
                  child: FadeSlideTransition(
                    delay: Duration(milliseconds: 200),
                    offset: Offset(24, 0),
                    child: _SkillsSphereView(),
                  ),
                ),
              ],
            ),
          ),
          // Text — layered on top, fills the full area
          Positioned.fill(
            child: _HeroText(personal: personal, onViewWork: onViewWork),
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
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: FadeSlideTransition(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _HeroText(personal: personal, onViewWork: onViewWork),
            ),
            const SizedBox(width: AppSpacing.xxl),
            const Expanded(
              flex: 2,
              child: Column(
                children: [
                  SizedBox(height: AppSpacing.xxl),
                  _HeroPhoto(size: 220),
                ],
              ),
            ),
          ],
        ),
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
    final nameStyle = isDesktop
        ? AppTextStyles.displayLarge
        : AppTextStyles.displayMedium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (personal.available) ...[
          const FadeSlideTransition(child: _AvailableBadge()),
          const SizedBox(height: AppSpacing.xl),
        ],
        WordStaggerText(
          text: personal.name,
          style: nameStyle,
          initialDelay: const Duration(milliseconds: 120),
          stagger: const Duration(milliseconds: 100),
        ),
        const SizedBox(height: AppSpacing.md),
        FadeSlideTransition(
          delay: const Duration(milliseconds: 420),
          child: Text(
            personal.subtitle,
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.muted,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        FadeSlideTransition(
          delay: const Duration(milliseconds: 560),
          child: Text(personal.tagline, style: AppTextStyles.bodyLarge),
        ),
        const SizedBox(height: AppSpacing.xxl),
        FadeSlideTransition(
          delay: const Duration(milliseconds: 700),
          child: Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              MagneticHover(
                child: DsButton(
                  label: AppStrings.viewWork,
                  onTap: onViewWork,
                ),
              ),
              MagneticHover(
                child: DsButton(
                  label: AppStrings.sayHi,
                  variant: DsButtonVariant.ghost,
                  onTap: () async {
                    final uri = Uri.parse('${CoreStrings.mailtoScheme}${personal.email}');
                    if (await canLaunchUrl(uri)) launchUrl(uri);
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        FadeSlideTransition(
          delay: const Duration(milliseconds: 820),
          child: Row(
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
        ),
      ],
    );
  }
}

class _AvailableBadge extends StatelessWidget {
  const _AvailableBadge();
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
            AppStrings.availableForWork,
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}

class _SkillsSphereView extends StatefulWidget {
  const _SkillsSphereView();

  @override
  State<_SkillsSphereView> createState() => _SkillsSphereViewState();
}

class _SkillsSphereViewState extends State<_SkillsSphereView> {
  static bool _registered = false;
  static String? _blobUrl;
  static const _viewType = CoreStrings.sphereViewType;
  StreamSubscription<html.MessageEvent>? _messageSub;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _loadSphere();
    _messageSub = html.window.onMessage.listen(_onIframeScroll);
  }

  Future<void> _loadSphere() async {
    if (_registered) {
      if (mounted) setState(() => _ready = true);
      return;
    }
    final content = await rootBundle.loadString(AppAssets.skillsSphere);
    final blob = html.Blob([content], 'text/html');
    _blobUrl = html.Url.createObjectUrl(blob);
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int id) => html.IFrameElement()
        ..src = _blobUrl!
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.background = 'transparent'
        ..setAttribute('allowtransparency', 'true')
        ..setAttribute('scrolling', 'no'),
    );
    _registered = true;
    if (mounted) setState(() => _ready = true);
  }

  void _onIframeScroll(html.MessageEvent event) {
    if (!mounted) return;
    final raw = event.data;
    if (raw is! String) return;
    Map<String, dynamic> data;
    try {
      data = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return;
    }
    if (data[CoreStrings.sphereEventTypeKey] != CoreStrings.sphereMessageType) return;
    final delta = (data[CoreStrings.sphereEventDeltaKey] as num?)?.toDouble() ?? 0.0;
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable == null) return;
    final pos = scrollable.position;
    pos.jumpTo((pos.pixels + delta).clamp(pos.minScrollExtent, pos.maxScrollExtent));
  }

  @override
  void dispose() {
    _messageSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return const SizedBox.expand();
    return const SizedBox.expand(
      child: HtmlElementView(viewType: _viewType),
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
          AppAssets.profilePhoto,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Center(
            child: Text(
              AppStrings.initials,
              style: AppTextStyles.displaySmall.copyWith(color: AppColors.accent),
            ),
          ),
        ),
      ),
    );
  }
}
