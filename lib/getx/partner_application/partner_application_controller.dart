import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../core/models/partner_application_draft.dart';
import '../../core/models/partner_uploaded_document.dart';
import '../../core/services/app_flash.dart';
import '../../core/services/app_log.dart';
import '../../data/repositories/user_repository.dart';
import '../../routes/app_routes.dart';

/// Sign-up → Partner Application (4 steps). Figma `1196:232`+.
///
/// Step 1: Basic Information · Step 2: Service Categories ·
/// Step 3: Verification & Documents · Step 4: Partner NDA.
class PartnerApplicationController extends GetxController {
  PartnerApplicationController({UserRepository? repository})
      : _users = repository ?? Get.find<UserRepository>();

  final UserRepository _users;

  static const String _tag = 'PARTNER_APP';
  static const int totalSteps = 4;
  static const String screenTitle = 'Partner Application';

  static const List<String> stepTitles = [
    'Basic Information',
    'Service Categories',
    'Verification & Documents',
    'RSRVD Partner NDA',
  ];

  static const List<({String id, String label})> serviceCategories = [
    (id: 'attorneys', label: 'Attorneys'),
    (id: 'cpas', label: 'CPAs'),
    (id: 'wealth_advisors', label: 'Wealth Advisors'),
    (id: 'contractors', label: 'Contractors'),
    (id: 'designers', label: 'Designers'),
    (id: 'architects', label: 'Architects'),
    (id: 'security', label: 'Security'),
    (id: 'av_home', label: 'AV / Home Automation'),
    (id: 'private_chefs', label: 'Private Chefs'),
    (id: 'private_gyms', label: 'Private Gyms / Wellness'),
    (id: 'private_trainers', label: 'Private Trainers'),
    (id: 'private_cars', label: 'Private Car Specialists'),
    (id: 'family_office', label: 'Family Office Support'),
  ];

  final contactNameController = TextEditingController();
  final phoneController = TextEditingController();
  final businessNameController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final experienceController = TextEditingController();
  final bioController = TextEditingController();
  final expertiseInputController = TextEditingController();
  final serviceAreaInputController = TextEditingController();

  final currentStep = 0.obs;
  final expertise = <String>[].obs;
  final serviceAreas = <String>[].obs;
  final selectedCategoryIds = <String>[].obs;
  final documents = <PartnerUploadedDocument>[].obs;
  final ndaAccepted = false.obs;
  final ndaSignedAt = Rxn<DateTime>();
  final isSubmitting = false.obs;

  static const String ndaVersion = 'v2.4';

  String get stepTitle => stepTitles[currentStep.value];

  String get headerSubtitle =>
      'Step ${currentStep.value + 1} of $totalSteps · $stepTitle';

  static const String reviewHeaderSubtitle = 'Final Review';

  bool get isLastStep => currentStep.value >= totalSteps - 1;

  String get primaryCtaLabel => isLastStep ? 'Continue' : 'Continue';

  String get personalName {
    final fromUser = _users.currentUser?.displayName.trim() ?? '';
    if (fromUser.isNotEmpty) return fromUser;
    final contact = contactNameController.text.trim();
    return contact.isNotEmpty ? contact : '-';
  }

  String get personalEmail {
    final email = _users.currentUser?.email.trim() ?? '';
    return email.isNotEmpty ? email : '-';
  }

  String get personalPhone {
    final phone = phoneController.text.trim();
    return phone.isNotEmpty ? phone : '-';
  }

  String get primaryContactDisplay {
    final name = contactNameController.text.trim();
    return name.isNotEmpty ? name : '-';
  }

  String get experienceDisplay {
    final raw = experienceController.text.trim();
    if (raw.isEmpty) return '-';
    if (RegExp(r'^\d+$').hasMatch(raw)) return '$raw Years';
    return raw;
  }

  String get expertiseDisplay =>
      expertise.isEmpty ? '-' : expertise.join(', ');

  String get serviceAreasDisplay =>
      serviceAreas.isEmpty ? '-' : serviceAreas.join(', ');

  String get categoryDisplay {
    final labels = serviceCategories
        .where((c) => selectedCategoryIds.contains(c.id))
        .map((c) => c.label)
        .toList();
    return labels.isEmpty ? '-' : labels.join(', ');
  }

  static const String docGovId = 'Government ID';
  static const String docDriving = 'Driving License';
  static const String docBusiness = 'Business Documents';

  String documentStatus(String docType) {
    final uploaded = documents.any((d) => d.docType == docType);
    return uploaded ? 'Uploaded' : '-';
  }

  String displayOrDash(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? '-' : trimmed;
  }

  String get ndaSignedBy {
    final name = contactNameController.text.trim();
    if (name.isNotEmpty) return name;
    return _users.currentUser?.displayName.trim().isNotEmpty == true
        ? _users.currentUser!.displayName
        : 'Partner';
  }

  String get ndaSignedDateLabel {
    final at = ndaSignedAt.value;
    if (at == null) return '';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[at.month - 1]} ${at.day}, ${at.year}';
  }

  String get ndaSignedTimeLabel {
    final at = ndaSignedAt.value;
    if (at == null) return '';
    final hour = at.hour % 12 == 0 ? 12 : at.hour % 12;
    final minute = at.minute.toString().padLeft(2, '0');
    final period = at.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  void onInit() {
    super.onInit();
    final existing = _users.currentUser;
    if (existing != null && contactNameController.text.isEmpty) {
      contactNameController.text = existing.displayName;
    }
  }

  @override
  void onClose() {
    final controllers = [
      contactNameController,
      phoneController,
      businessNameController,
      cityController,
      stateController,
      countryController,
      experienceController,
      bioController,
      expertiseInputController,
      serviceAreaInputController,
    ];
    SchedulerBinding.instance.addPostFrameCallback((_) {
      for (final c in controllers) {
        c.dispose();
      }
    });
    super.onClose();
  }

  void goBack() {
    if (currentStep.value > 0) {
      currentStep.value--;
      return;
    }
    Get.back();
  }

  void onPrimaryCta() {
    if (!_validateCurrentStep()) return;
    if (isLastStep) {
      Get.toNamed(AppRoutes.partnerApplicationReview);
      return;
    }
    currentStep.value++;
    AppLog.i('advance → step ${currentStep.value + 1}', tag: _tag);
  }

  void editSection(int step) {
    if (step < 0 || step >= totalSteps) return;
    currentStep.value = step;
    Get.back();
  }

  Future<void> submitApplication() => _submit();

  bool _validateCurrentStep() {
    switch (currentStep.value) {
      case 0:
        if (phoneController.text.trim().isEmpty ||
            bioController.text.trim().isEmpty ||
            expertise.isEmpty ||
            serviceAreas.isEmpty) {
          AppFlash.error('auth_fill_required'.tr);
          return false;
        }
        return true;
      case 1:
        if (selectedCategoryIds.isEmpty) {
          AppFlash.error('pa_select_category'.tr);
          return false;
        }
        return true;
      case 2:
        return true;
      case 3:
        if (!ndaAccepted.value) {
          AppFlash.error('pa_nda_required'.tr);
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  Future<void> _submit() async {
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    try {
      final draft = toDraft();
      await _users.completePartnerApplication(draft);
      AppLog.i('submitted ${draft.businessName}', tag: _tag);
      Get.offAllNamed(AppRoutes.applicationStatus);
    } finally {
      isSubmitting.value = false;
    }
  }

  PartnerApplicationDraft toDraft() {
    return PartnerApplicationDraft(
      contactName: contactNameController.text.trim(),
      phone: phoneController.text.trim(),
      businessName: businessNameController.text.trim(),
      city: cityController.text.trim(),
      state: stateController.text.trim(),
      country: countryController.text.trim(),
      experienceYears: experienceController.text.trim(),
      bio: bioController.text.trim(),
      expertise: List<String>.from(expertise),
      serviceAreas: List<String>.from(serviceAreas),
      categoryIds: List<String>.from(selectedCategoryIds),
      documents: List<PartnerUploadedDocument>.from(documents),
      ndaAccepted: ndaAccepted.value,
    );
  }

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

  void toggleCategory(String id) {
    if (selectedCategoryIds.contains(id)) {
      selectedCategoryIds.remove(id);
    } else {
      selectedCategoryIds.add(id);
    }
  }

  void toggleNda() {
    ndaAccepted.toggle();
    if (ndaAccepted.value) {
      ndaSignedAt.value = DateTime.now();
    } else {
      ndaSignedAt.value = null;
    }
  }

  /// Local demo upload — real picker lands with backend.
  void addDemoDocument(String docTypeKey) {
    final docType = switch (docTypeKey) {
      'pa_doc_gov_id' => docGovId,
      'pa_doc_driving' => docDriving,
      'pa_doc_business' => docBusiness,
      _ => docTypeKey.tr,
    };
    final slug = docType
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    final count =
        documents.where((d) => d.docType == docType).length + 1;
    documents.add(
      PartnerUploadedDocument(
        id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
        fileName: '${slug}_$count.PDF',
        docType: docType,
        uploadedAt: DateTime.now(),
      ),
    );
  }

  void retryDocument(String id) {
    AppFlash.info('coming_soon'.tr);
  }

  void removeDocument(String id) {
    documents.removeWhere((d) => d.id == id);
  }
}
