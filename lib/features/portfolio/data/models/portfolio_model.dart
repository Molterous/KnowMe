import '../../domain/entities/portfolio_entity.dart';

class PortfolioModel {
  static PortfolioEntity fromMap(Map<String, dynamic> map) => PortfolioEntity(
        personal: _parsePersonal(map['personal'] as Map<String, dynamic>),
        about: _parseAbout(map['about'] as Map<String, dynamic>),
        experience: (map['experience'] as List)
            .map((e) => _parseExperience(e as Map<String, dynamic>))
            .toList(),
        projects: (map['projects'] as List)
            .map((e) => _parseProject(e as Map<String, dynamic>))
            .toList(),
        skills: _parseSkills(map['skills'] as Map<String, dynamic>),
        education: _parseEducation(map['education'] as Map<String, dynamic>),
      );

  static PersonalEntity _parsePersonal(Map<String, dynamic> m) {
    final links = m['links'] as Map<String, dynamic>;
    return PersonalEntity(
      name: m['name'] as String,
      title: m['title'] as String,
      subtitle: m['subtitle'] as String,
      tagline: m['tagline'] as String,
      email: m['email'] as String,
      phone: m['phone'] as String,
      location: m['location'] as String,
      available: m['available'] as bool,
      links: links.map((k, v) => MapEntry(k, v as String)),
    );
  }

  static AboutEntity _parseAbout(Map<String, dynamic> m) => AboutEntity(
        bio: m['bio'] as String,
        highlights: List<String>.from(m['highlights'] as List),
        personalityChips: List<String>.from(m['personality_chips'] as List),
      );

  static ExperienceEntity _parseExperience(Map<String, dynamic> m) =>
      ExperienceEntity(
        id: m['id'] as String,
        company: m['company'] as String,
        role: m['role'] as String,
        type: m['type'] as String,
        location: m['location'] as String,
        duration: m['duration'] as String,
        current: m['current'] as bool,
        summary: m['summary'] as String,
        highlights: List<String>.from(m['highlights'] as List),
        metrics: List<String>.from(m['metrics'] as List),
        tech: List<String>.from(m['tech'] as List),
      );

  static ProjectEntity _parseProject(Map<String, dynamic> m) => ProjectEntity(
        id: m['id'] as String,
        title: m['title'] as String,
        subtitle: m['subtitle'] as String,
        platform: List<String>.from(m['platform'] as List),
        status: ProjectStatus.fromJson(m['status'] as String),
        description: m['description'] as String,
        highlights: List<String>.from(m['highlights'] as List),
        tech: List<String>.from(m['tech'] as List),
        metrics: List<String>.from(m['metrics'] as List),
        links: (m['links'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String)) ??
            {},
        images: List<String>.from((m['images'] as List?) ?? []),
      );

  static SkillsEntity _parseSkills(Map<String, dynamic> m) => SkillsEntity(
        languages: List<String>.from(m['languages'] as List),
        frameworks: List<String>.from(m['frameworks'] as List),
        architecture: List<String>.from(m['architecture'] as List),
        tools: List<String>.from(m['tools'] as List),
        cloud: List<String>.from(m['cloud'] as List),
        expertise: List<String>.from(m['expertise'] as List),
      );

  static EducationEntity _parseEducation(Map<String, dynamic> m) =>
      EducationEntity(
        degree: m['degree'] as String,
        institution: m['institution'] as String,
        affiliation: m['affiliation'] as String,
        cgpa: m['cgpa'] as String,
        year: m['year'] as String,
      );
}
