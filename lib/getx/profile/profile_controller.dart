import 'package:get/get.dart';

import '../../core/services/app_log.dart';
import '../../data/repositories/profile_repository.dart';
import '../../routes/app_routes.dart';

class ProfileController extends GetxController {
  ProfileController({ProfileRepository? repository})
      : _repository = repository ?? Get.find<ProfileRepository>();

  final ProfileRepository _repository;
  static const String _tag = 'PROFILE';

  final isLoading = true.obs;
  final displayName = ''.obs;
  final subtitle = ''.obs;
  final initials = ''.obs;
  final bio = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final primaryCategory = ''.obs;
  final experience = ''.obs;
  final expertise = ''.obs;
  final serviceAreas = ''.obs;

  List<({String label, String value})> get overviewRows => [
        (label: 'Name', value: displayName.value),
        (label: 'Email', value: email.value),
        (label: 'Phone', value: phone.value),
        (label: 'Primary Category', value: primaryCategory.value),
        (label: 'Experience', value: experience.value),
        (label: 'Area of Expertise', value: expertise.value),
        (label: 'Service Areas', value: serviceAreas.value),
      ];

  @override
  void onInit() {
    super.onInit();
    loadFeed();
  }

  Future<void> loadFeed() async {
    isLoading.value = true;
    try {
      final feed = await _repository.fetchProfileFeed();
      displayName.value = feed.displayName;
      subtitle.value = feed.subtitle;
      initials.value = feed.initials;
      bio.value = feed.bio;
      email.value = feed.email;
      phone.value = feed.phone;
      primaryCategory.value = feed.primaryCategory;
      experience.value = feed.experience;
      expertise.value = feed.expertise;
      serviceAreas.value = feed.serviceAreas;
    } catch (e, st) {
      AppLog.e('loadFeed failed: $e', tag: _tag, error: e, stackTrace: st);
    } finally {
      isLoading.value = false;
    }
  }

  void openSettings() => Get.toNamed(AppRoutes.settings);
}
