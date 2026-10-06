import 'package:get/get.dart';

import '../../core/models/profile_feed.dart';
import '../../core/services/app_log.dart';
import 'user_repository.dart';

/// Partners Profile tab data — Figma `1196:3096`.
class ProfileRepository extends GetxService {
  ProfileRepository({UserRepository? users})
      : _users = users ?? Get.find<UserRepository>();

  final UserRepository _users;
  static const String _tag = 'PROFILE_REPO';

  Future<ProfileFeed> fetchProfileFeed() async {
    AppLog.i('fetchProfileFeed', tag: _tag);
    await Future<void>.delayed(const Duration(milliseconds: 40));
    final user = _users.currentUser;
    final draft = _users.partnerApplication;

    final name = _firstNonEmpty([
      user?.displayName,
      draft?.contactName,
      draft?.businessName,
    ]) ??
        'Alexa Miguel';
    final email = _firstNonEmpty([user?.email]) ?? 'alexa@gmail.com';
    final phone = _firstNonEmpty([draft?.phone]) ?? '+1 234 560 7890';
    final primaryCategory = _primaryCategory(user?.occupation) ?? 'Architect';
    final experience = _experienceDisplay(draft?.experienceYears) ?? '08 years';
    final expertiseList = draft?.expertise.isNotEmpty == true
        ? draft!.expertise
        : const ['Renovation', 'Art Curation'];
    final serviceAreasList = draft?.serviceAreas.isNotEmpty == true
        ? draft!.serviceAreas
        : const ['Zürich', 'Geneva', 'Basel'];
    final city = draft?.city.trim() ?? '';
    final subtitle = [
      if (primaryCategory.isNotEmpty) primaryCategory,
      if (city.isNotEmpty) city,
    ].join(' · ');
    final initials = (user?.initials.isNotEmpty == true)
        ? user!.initials
        : _initialsFrom(name);
    final bio = _firstNonEmpty([draft?.bio]) ??
        'Marchetti Atelier designs private residences for collectors and '
            'principals who expect discretion, craft and precision. Every '
            'commission is led personally by Alexa Miguel.';

    return ProfileFeed(
      displayName: name,
      subtitle: subtitle.isNotEmpty ? subtitle : 'Architect · Zurich',
      initials: initials.isNotEmpty ? initials : 'AM',
      bio: bio,
      email: email,
      phone: phone,
      primaryCategory: primaryCategory,
      experience: experience,
      expertise: expertiseList.join(', '),
      serviceAreas: serviceAreasList.join(', '),
    );
  }

  String? _primaryCategory(String? occupation) {
    final fromOcc = occupation?.trim();
    if (fromOcc == null || fromOcc.isEmpty) return null;
    // occupation may be "Architect · Zurich" from onboarding.
    return fromOcc.split('·').first.trim();
  }

  String? _experienceDisplay(String? raw) {
    final value = raw?.trim();
    if (value == null || value.isEmpty) return null;
    if (RegExp(r'^\d+$').hasMatch(value)) {
      return '${value.padLeft(2, '0')} years';
    }
    return value;
  }

  String? _firstNonEmpty(List<String?> values) {
    for (final v in values) {
      final t = v?.trim();
      if (t != null && t.isNotEmpty) return t;
    }
    return null;
  }

  String _initialsFrom(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      final w = parts.first;
      return w.substring(0, w.length.clamp(0, 2)).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
