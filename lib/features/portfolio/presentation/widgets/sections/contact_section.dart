import 'package:flutter/material.dart';
import 'package:ds_core/ds_core.dart';
import '../../../domain/entities/portfolio_entity.dart';
import '../../../../../../core/utils/app_strings.dart';
import '../../../../../../core/utils/core_strings.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({
    super.key,
    required this.personal,
    required this.onLinkTap,
  });

  final PersonalEntity personal;
  final void Function(String url) onLinkTap;

  @override
  Widget build(BuildContext context) {
    return FadeSlideTransition(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
          number: AppStrings.sectionNumContact,
          title: AppStrings.sectionTitleContact,
        ),
          const SizedBox(height: AppSpacing.xxl),
          ResponsiveBuilder(
            mobile: _ContactMobile(personal: personal, onLinkTap: onLinkTap),
            desktop: _ContactDesktop(personal: personal, onLinkTap: onLinkTap),
          ),
        ],
      ),
    );
  }
}

class _ContactDesktop extends StatelessWidget {
  const _ContactDesktop({required this.personal, required this.onLinkTap});
  final PersonalEntity personal;
  final void Function(String) onLinkTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _EmailButton(email: personal.email, onTap: onLinkTap),
              const SizedBox(height: AppSpacing.xl),
              _SocialLinks(links: personal.links, onLinkTap: onLinkTap),
            ],
          ),
        ),
        Text(
          personal.location,
          style: AppTextStyles.displaySmall.copyWith(
            color: AppColors.surface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ContactMobile extends StatelessWidget {
  const _ContactMobile({required this.personal, required this.onLinkTap});
  final PersonalEntity personal;
  final void Function(String) onLinkTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _EmailButton(email: personal.email, onTap: onLinkTap),
        const SizedBox(height: AppSpacing.xl),
        _SocialLinks(links: personal.links, onLinkTap: onLinkTap),
      ],
    );
  }
}

class _EmailButton extends StatelessWidget {
  const _EmailButton({required this.email, required this.onTap});
  final String email;
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
      onTap: () => onTap('${CoreStrings.mailtoScheme}$email'),
      builder: (_, isHovered) => AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 150),
        style: (context.isDesktop
                ? AppTextStyles.headlineLarge
                : AppTextStyles.headlineMedium)
            .copyWith(
          color: isHovered ? AppColors.accent : AppColors.primaryText,
          decoration: isHovered ? TextDecoration.underline : TextDecoration.none,
          decorationColor: AppColors.accent,
        ),
        child: Text(email),
      ),
    );
  }
}

class _SocialLinks extends StatelessWidget {
  const _SocialLinks({required this.links, required this.onLinkTap});
  final Map<String, String> links;
  final void Function(String) onLinkTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: links.entries.map((e) => DsButton(
        label: e.key.toUpperCase(),
        variant: DsButtonVariant.ghost,
        onTap: () => onLinkTap(e.value),
      )).toList(),
    );
  }
}
