/// Partners Profile tab payload — Figma `1196:3096`.
class ProfileFeed {
  const ProfileFeed({
    required this.displayName,
    required this.subtitle,
    required this.initials,
    required this.bio,
    required this.email,
    required this.phone,
    required this.primaryCategory,
    required this.experience,
    required this.expertise,
    required this.serviceAreas,
  });

  final String displayName;

  /// e.g. `Architect · Zurich`
  final String subtitle;
  final String initials;
  final String bio;
  final String email;
  final String phone;
  final String primaryCategory;
  final String experience;
  final String expertise;
  final String serviceAreas;
}
