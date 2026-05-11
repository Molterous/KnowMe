import 'package:flutter/material.dart';
import 'package:ds_core/ds_core.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/portfolio_entity.dart';
import '../../../../../core/utils/core_strings.dart';
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
  String _activeSection = CoreStrings.sectionHero;

  final _heroKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _workKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final sections = [
      (CoreStrings.sectionHero, _heroKey),
      (CoreStrings.sectionAbout, _aboutKey),
      (CoreStrings.sectionWork, _workKey),
      (CoreStrings.sectionProjects, _projectsKey),
      (CoreStrings.sectionSkills, _skillsKey),
      (CoreStrings.sectionContact, _contactKey),
    ];

    String current = CoreStrings.sectionHero;
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
      CoreStrings.sectionAbout => _aboutKey,
      CoreStrings.sectionExperience => _workKey,
      CoreStrings.sectionProjects => _projectsKey,
      CoreStrings.sectionSkills => _skillsKey,
      CoreStrings.sectionContact => _contactKey,
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

                    // Hero
                    SizedBox(key: _heroKey, height: AppSpacing.xxl),
                    HeroSection(
                      personal: widget.data.personal,
                      onViewWork: () => _scrollToSection(CoreStrings.sectionProjects),
                    ),
                    SizedBox(key: _aboutKey, height: AppSpacing.xxl),

                    // About
                    ScrollReveal(
                      shimmer: const AboutSectionShimmer(),
                      child: AboutSection(
                        about: widget.data.about,
                        education: widget.data.education,
                      ),
                    ),
                    SizedBox(key: _workKey, height: AppSpacing.xxl),

                    // Experience
                    ScrollReveal(
                      shimmer: const SectionShimmer(
                        cardCount: 2,
                        cardShimmer: ExperienceCardShimmer(),
                      ),
                      child: ExperiencePreviewSection(
                        experience: widget.data.experience,
                      ),
                    ),
                    SizedBox(key: _projectsKey, height: AppSpacing.xxl),

                    // Projects
                    ScrollReveal(
                      shimmer: const SectionShimmer(
                        cardCount: 1,
                        cardShimmer: ProjectCardShimmer(),
                      ),
                      child: ProjectsPreviewSection(
                        projects: widget.data.projects,
                      ),
                    ),
                    SizedBox(key: _skillsKey, height: AppSpacing.xxl),

                    // Skills
                    ScrollReveal(
                      shimmer: const SkillsSectionShimmer(),
                      child: SkillsSection(skills: widget.data.skills),
                    ),
                    SizedBox(key: _contactKey, height: AppSpacing.xxl),

                    // Contact
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
