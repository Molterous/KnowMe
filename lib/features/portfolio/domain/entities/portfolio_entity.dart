import 'package:equatable/equatable.dart';

class PortfolioEntity extends Equatable {
  final PersonalEntity personal;
  final AboutEntity about;
  final List<ExperienceEntity> experience;
  final List<ProjectEntity> projects;
  final SkillsEntity skills;
  final EducationEntity education;

  const PortfolioEntity({
    required this.personal,
    required this.about,
    required this.experience,
    required this.projects,
    required this.skills,
    required this.education,
  });

  @override
  List<Object> get props =>
      [personal, about, experience, projects, skills, education];
}

class PersonalEntity extends Equatable {
  final String name;
  final String title;
  final String subtitle;
  final String tagline;
  final String email;
  final String phone;
  final String location;
  final bool available;
  final Map<String, String> links;

  const PersonalEntity({
    required this.name,
    required this.title,
    required this.subtitle,
    required this.tagline,
    required this.email,
    required this.phone,
    required this.location,
    required this.available,
    required this.links,
  });

  @override
  List<Object> get props =>
      [name, title, subtitle, tagline, email, phone, location, available, links];
}

class AboutEntity extends Equatable {
  final String bio;
  final List<String> highlights;
  final List<String> personalityChips;

  const AboutEntity({
    required this.bio,
    required this.highlights,
    required this.personalityChips,
  });

  @override
  List<Object> get props => [bio, highlights, personalityChips];
}

class ExperienceEntity extends Equatable {
  final String id;
  final String company;
  final String role;
  final String type;
  final String location;
  final String duration;
  final bool current;
  final String summary;
  final List<String> highlights;
  final List<String> metrics;
  final List<String> tech;

  const ExperienceEntity({
    required this.id,
    required this.company,
    required this.role,
    required this.type,
    required this.location,
    required this.duration,
    required this.current,
    required this.summary,
    required this.highlights,
    required this.metrics,
    required this.tech,
  });

  @override
  List<Object> get props => [id, company, role, duration];
}

enum ProjectStatus {
  completed,
  inReview,
  githubRelease;

  static ProjectStatus fromJson(String value) => switch (value) {
        'in_review' => ProjectStatus.inReview,
        'github_release' => ProjectStatus.githubRelease,
        _ => ProjectStatus.completed,
      };
}

class ProjectEntity extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final List<String> platform;
  final ProjectStatus status;
  final String description;
  final List<String> highlights;
  final List<String> tech;
  final List<String> metrics;
  final Map<String, String> links;
  final List<String> images;

  const ProjectEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.platform,
    required this.status,
    required this.description,
    required this.highlights,
    required this.tech,
    required this.metrics,
    this.links = const {},
    this.images = const [],
  });

  @override
  List<Object> get props => [id, title, status];
}


class SkillsEntity extends Equatable {
  final List<String> languages;
  final List<String> frameworks;
  final List<String> architecture;
  final List<String> tools;
  final List<String> cloud;
  final List<String> expertise;

  const SkillsEntity({
    required this.languages,
    required this.frameworks,
    required this.architecture,
    required this.tools,
    required this.cloud,
    required this.expertise,
  });

  @override
  List<Object> get props =>
      [languages, frameworks, architecture, tools, cloud, expertise];
}

class EducationEntity extends Equatable {
  final String degree;
  final String institution;
  final String affiliation;
  final String cgpa;
  final String year;

  const EducationEntity({
    required this.degree,
    required this.institution,
    required this.affiliation,
    required this.cgpa,
    required this.year,
  });

  @override
  List<Object> get props => [degree, institution, cgpa, year];
}
