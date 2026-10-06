import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/app_flash.dart';
import '../../core/services/app_log.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../home/home_controller.dart';
import '../profile/profile_controller.dart';

class EditProfileController extends GetxController {
  EditProfileController({
    SettingsRepository? repository,
    ProfileRepository? profileRepository,
  })  : _repository = repository ?? Get.find<SettingsRepository>(),
        _profileRepository =
            profileRepository ?? Get.find<ProfileRepository>();

  final SettingsRepository _repository;
  final ProfileRepository _profileRepository;
  static const String _tag = 'EDIT_PROFILE';

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final primaryCategoryController = TextEditingController();
  final experienceController = TextEditingController();
  final expertiseInputController = TextEditingController();
  final serviceAreaInputController = TextEditingController();

  final expertise = <String>[].obs;
  final serviceAreas = <String>[].obs;
  final initials = ''.obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
    nameController.addListener(_syncInitials);
  }

  Future<void> _load() async {
    final feed = await _profileRepository.fetchProfileFeed();
    nameController.text = feed.displayName;
    emailController.text = feed.email;
    phoneController.text = feed.phone;
    primaryCategoryController.text = feed.primaryCategory;
    experienceController.text = feed.experience;
    expertise.assignAll(_splitCsv(feed.expertise));
    serviceAreas.assignAll(_splitCsv(feed.serviceAreas));
    initials.value =
        feed.initials.isNotEmpty ? feed.initials : _initialsFrom(nameController.text);
  }

  List<String> _splitCsv(String raw) {
    return raw
        .split(RegExp(r'\s*,\s*'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  void _syncInitials() {
    initials.value = _initialsFrom(nameController.text);
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

  @override
  void onClose() {
    nameController.removeListener(_syncInitials);
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    primaryCategoryController.dispose();
    experienceController.dispose();
    expertiseInputController.dispose();
    serviceAreaInputController.dispose();
    super.onClose();
  }

  void goBack() => Get.back();

  void changeAvatar() => AppFlash.info('coming_soon'.tr);

  void addExpertise(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return;
    if (!expertise.contains(value)) expertise.add(value);
    expertiseInputController.clear();
  }

  void removeExpertise(String value) => expertise.remove(value);

  void addServiceArea(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return;
    if (!serviceAreas.contains(value)) serviceAreas.add(value);
    serviceAreaInputController.clear();
  }

  void removeServiceArea(String value) => serviceAreas.remove(value);

  Future<void> saveChanges() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final category = primaryCategoryController.text.trim();
    if (name.isEmpty || email.isEmpty || phone.isEmpty || category.isEmpty) {
      AppFlash.info('auth_fill_required'.tr);
      return;
    }
    if (expertise.isEmpty || serviceAreas.isEmpty) {
      AppFlash.info('auth_fill_required'.tr);
      return;
    }

    isSaving.value = true;
    try {
      await _repository.updateProfile(
        displayName: name,
        email: email,
        occupation: category,
        phone: phone,
        experienceYears: experienceController.text.trim(),
        expertise: List<String>.from(expertise),
        serviceAreas: List<String>.from(serviceAreas),
      );
      if (Get.isRegistered<ProfileController>()) {
        await Get.find<ProfileController>().loadFeed();
      }
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().update();
      }
      AppFlash.success('Profile updated');
      Get.back();
    } catch (e, st) {
      AppLog.e('saveChanges failed: $e', tag: _tag, error: e, stackTrace: st);
      AppFlash.info('Could not save profile');
    } finally {
      isSaving.value = false;
    }
  }
}
