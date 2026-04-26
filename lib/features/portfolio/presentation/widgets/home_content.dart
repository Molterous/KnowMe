import 'package:flutter/material.dart';
import 'package:ds_core/ds_core.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/portfolio_entity.dart';
import 'nav_bar.dart';
import 'portfolio_footer.dart';
import 'sections/hero_section.dart';
import 'sections/about_section.dart';
import 'sections/experience_preview_section.dart';
import 'sections/projects_preview_section.dart';
import 'sections/skills_section.dart';
import 'sections/contact_section.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key, required this.data});
  final PortfolioEntity data;

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final _scrollController = ScrollController();
  String _activeSection = 'hero';

  final _heroKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _workKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final sections = [
      ('hero', _heroKey),
      ('about', _aboutKey),
      ('work', _workKey),
      ('skills', _skillsKey),
      ('contact', _contactKey),
    ];

    String current = 'hero';
    for (final (name, key) in sections) {
      final ctx = key.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final offset = box.localToGlobal(Offset.zero);
      if (offset.dy < MediaQuery.sizeOf(context).height * 0.5) {
        current = name;
      }
    }
    if (current != _activeSection) setState(() => _activeSection = current);
  }

  void _scrollToSection(String section) {
    final key = switch (section) {
      'about' => _aboutKey,
      'work' => _workKey,
      'skills' => _skillsKey,
      'contact' => _contactKey,
      _ => _heroKey,
    };
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hPad = context.responsive<double>(
      mobile: AppSpacing.lg,
      tablet: AppSpacing.xl,
      desktop: AppSpacing.xxxl,
    );

    return Column(
      children: [
        PortfolioNavBar(
          onSectionTap: _scrollToSection,
          scrollController: _scrollController,
          activeSection: _activeSection,
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: MaxWidthBox(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // main section
                    SizedBox(key: _heroKey, height: AppSpacing.xxl),
                    HeroSection(
                      personal: widget.data.personal,
                      onViewWork: () => _scrollToSection('work'),
                    ),
                    SizedBox(key: _aboutKey, height: AppSpacing.xxl),

                    // About Section
                    ScrollReveal(
                      shimmer: const AboutSectionShimmer(),
                      child: AboutSection(
                        about: widget.data.about,
                        education: widget.data.education,
                      ),
                    ),
                    SizedBox(key: _workKey, height: AppSpacing.xxl),

                    // Experience Preview Section
                    ScrollReveal(
                      shimmer: const SectionShimmer(
                        cardCount: 2,
                        cardShimmer: ExperienceCardShimmer(),
                      ),
                      child: ExperiencePreviewSection(
                        experience: widget.data.experience,
                        onViewAll: () => context.go('/experience'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Projects Preview Section
                    ScrollReveal(
                      shimmer: const SectionShimmer(
                        cardCount: 2,
                        cardShimmer: ProjectCardShimmer(),
                      ),
                      child: ProjectsPreviewSection(
                        projects: widget.data.projects,
                        onViewAll: () => context.go('/projects'),
                        onProjectTap: (id) => context.go('/projects/$id'),
                      ),
                    ),
                    SizedBox(key: _skillsKey, height: AppSpacing.md),

                    // Skills Section
                    ScrollReveal(
                      shimmer: const SkillsSectionShimmer(),
                      child: SkillsSection(skills: widget.data.skills),
                    ),
                    SizedBox(key: _contactKey, height: AppSpacing.xxl),

                    // Contact Section
                    ScrollReveal(
                      shimmer: const ContactSectionShimmer(),
                      child: ContactSection(
                        personal: widget.data.personal,
                        onLinkTap: (url) async {
                          final uri = Uri.parse(url);
                          if (await canLaunchUrl(uri)) launchUrl(uri);
                        },
                      ),
                    ),

                    // footer
                    const PortfolioFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
