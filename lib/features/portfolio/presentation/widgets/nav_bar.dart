import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ds_core/ds_core.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/core_strings.dart';

class PortfolioNavBar extends StatefulWidget {
  const PortfolioNavBar({super.key, this.onSectionTap, this.scrollController, this.activeSection});

  final void Function(String section)? onSectionTap;
  final ScrollController? scrollController;
  final String? activeSection;

  @override
  State<PortfolioNavBar> createState() => _PortfolioNavBarState();
}

class _PortfolioNavBarState extends State<PortfolioNavBar> {
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(PortfolioNavBar old) {
    super.didUpdateWidget(old);
    if (old.scrollController != widget.scrollController) {
      old.scrollController?.removeListener(_onScroll);
      widget.scrollController?.addListener(_onScroll);
    }
  }

  void _onScroll() {
    final isScrolled = (widget.scrollController?.offset ?? 0) > 40;
    if (isScrolled != _scrolled) setState(() => _scrolled = isScrolled);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = _NavContent(
      onSectionTap: widget.onSectionTap,
      activeSection: widget.activeSection,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: _scrolled
            ? AppColors.background.withOpacity(0.85)
            : AppColors.background,
        border: Border(
          bottom: BorderSide(
            color: _scrolled ? AppColors.divider : Colors.transparent,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_scrolled && context.isDesktop)
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: content,
              ),
            )
          else
            content,
          if (widget.scrollController != null)
            ScrollProgressBar(controller: widget.scrollController!),
        ],
      ),
    );
  }
}

class _NavContent extends StatelessWidget {
  const _NavContent({this.onSectionTap, this.activeSection});
  final void Function(String)? onSectionTap;
  final String? activeSection;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: _MobileNavBar(onSectionTap: onSectionTap),
      desktop: _DesktopNavBar(onSectionTap: onSectionTap, activeSection: activeSection),
    );
  }
}

// ── Desktop / Tablet ──────────────────────────────────────────────────────────

class _DesktopNavBar extends StatelessWidget {
  const _DesktopNavBar({this.onSectionTap, this.activeSection});
  final void Function(String)? onSectionTap;
  final String? activeSection;

  @override
  Widget build(BuildContext context) {
    final horizontalPad = context.responsive<double>(
      mobile: AppSpacing.lg,
      tablet: AppSpacing.xl,
      desktop: AppSpacing.xxxl,
    );

    return SizedBox(
      height: 72,
      child: MaxWidthBox(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPad),
          child: Row(
            children: [
              _Logo(onTap: () => onSectionTap?.call(CoreStrings.sectionHero)),
              const Spacer(),
              _NavLink(
                label: AppStrings.navAbout,
                active: activeSection == CoreStrings.sectionAbout,
                onTap: () => onSectionTap?.call(CoreStrings.sectionAbout),
              ),
              const SizedBox(width: AppSpacing.xl),
              _NavLink(
                label: AppStrings.navExperience,
                active: activeSection == CoreStrings.sectionWork,
                onTap: () => onSectionTap?.call(CoreStrings.sectionExperience),
              ),
              const SizedBox(width: AppSpacing.xl),
              _NavLink(
                label: AppStrings.navProjects,
                active: activeSection == CoreStrings.sectionProjects,
                onTap: () => onSectionTap?.call(CoreStrings.sectionProjects),
              ),
              const SizedBox(width: AppSpacing.xl),
              _NavLink(
                label: AppStrings.navSkills,
                active: activeSection == CoreStrings.sectionSkills,
                onTap: () => onSectionTap?.call(CoreStrings.sectionSkills),
              ),
              const SizedBox(width: AppSpacing.xl),
              _NavLink(
                label: AppStrings.navContact,
                active: activeSection == CoreStrings.sectionContact,
                onTap: () => onSectionTap?.call(CoreStrings.sectionContact),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Mobile ────────────────────────────────────────────────────────────────────

class _MobileNavBar extends StatelessWidget {
  const _MobileNavBar({this.onSectionTap});
  final void Function(String)? onSectionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          _Logo(onTap: () => onSectionTap?.call(CoreStrings.sectionAbout)),
          const Spacer(),
          HoverWidget(
            onTap: () => _openDrawer(context),
            builder: (_, isHovered) => AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: isHovered ? AppColors.surface : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.menu_rounded,
                color: isHovered ? AppColors.accent : AppColors.primaryText,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _MobileMenu(
        onSectionTap: (section) {
          Navigator.pop(context);
          onSectionTap?.call(section);
        },
      ),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  const _MobileMenu({required this.onSectionTap});
  final void Function(String) onSectionTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.muted.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          _MenuTile(label: AppStrings.navAbout, onTap: () => onSectionTap(CoreStrings.sectionAbout)),
          _MenuTile(label: AppStrings.navExperience, onTap: () => onSectionTap(CoreStrings.sectionExperience)),
          _MenuTile(label: AppStrings.navProjects, onTap: () => onSectionTap(CoreStrings.sectionProjects)),
          _MenuTile(label: AppStrings.navSkills, onTap: () => onSectionTap(CoreStrings.sectionSkills)),
          _MenuTile(label: AppStrings.navContact, onTap: () => onSectionTap(CoreStrings.sectionContact)),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
      onTap: onTap,
      builder: (_, isHovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.divider, width: 1),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.headlineMedium.copyWith(
            color: isHovered ? AppColors.accent : AppColors.primaryText,
          ),
        ),
      ),
    );
  }
}

// ── Shared ────────────────────────────────────────────────────────────────────

class _Logo extends StatelessWidget {
  const _Logo({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
      onTap: onTap,
      builder: (_, isHovered) => Text(
        AppStrings.logo,
        style: AppTextStyles.headlineLarge.copyWith(
          color: isHovered ? AppColors.accent : AppColors.primaryText,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.onTap, this.active = false});
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
      onTap: onTap,
      builder: (_, isHovered) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: AppTextStyles.titleMedium.copyWith(
              color: (isHovered || active) ? AppColors.accent : AppColors.muted,
            ),
            child: Text(label),
          ),
          const SizedBox(height: 3),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: active ? 20 : 0,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
}
