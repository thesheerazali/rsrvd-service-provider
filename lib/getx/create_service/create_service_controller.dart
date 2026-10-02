import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../core/models/partner_service.dart';
import '../../core/services/app_flash.dart';
import '../../core/styles/app_colors.dart';
import '../../presentation/widgets/app_confirm_dialog.dart';
import '../../routes/app_routes.dart';
import '../main_shell/main_shell_controller.dart';
import '../services/services_controller.dart';

/// Create / Edit Service — same form; edit when `service_id` is passed.
class CreateServiceController extends GetxController {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController priceController;

  final category = 'Architect'.obs;
  final imageSlots = <int>[].obs;
  final isPublishing = false.obs;
  final editingServiceId = ''.obs;

  static const maxImages = 6;

  final categories = const [
    'Architect',
    'Interior Design',
    'Landscape',
    'Project Architect',
    'Consulting',
  ];

  bool get isEditing => editingServiceId.value.isNotEmpty;

  bool get canAddImage => imageSlots.length < maxImages;

  String get screenTitle =>
      isEditing ? 'edit_service_title'.tr : 'create_service_title'.tr;

  String get primaryCtaLabel =>
      isEditing ? 'edit_service_save_cta'.tr : 'create_service_publish_cta'.tr;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    priceController = TextEditingController();
    _hydrateFromArgs();
  }

  void _hydrateFromArgs() {
    final args = Get.arguments;
    String? id;
    if (args is String) id = args;
    if (args is Map && args['service_id'] is String) {
      id = args['service_id'] as String;
    }
    if (id == null || id.isEmpty) return;
    if (!Get.isRegistered<ServicesController>()) return;

    PartnerService? match;
    for (final s in Get.find<ServicesController>().services) {
      if (s.id == id) {
        match = s;
        break;
      }
    }
    if (match == null) return;

    editingServiceId.value = match.id;
    nameController.text = match.title;
    descriptionController.text = match.description;
    category.value = match.category;
    priceController.text = _priceDigits(match.priceLabel);
    imageSlots.assignAll(List.generate(match.imageCount.clamp(0, maxImages), (i) => i));
  }

  static String _priceDigits(String priceLabel) {
    final match = RegExp(r'[\d,\.]+').firstMatch(priceLabel);
    return match?.group(0)?.replaceAll(',', '') ?? '';
  }

  @override
  void onClose() {
    final controllers = [
      nameController,
      descriptionController,
      priceController,
    ];
    SchedulerBinding.instance.addPostFrameCallback((_) {
      for (final c in controllers) {
        c.dispose();
      }
    });
    super.onClose();
  }

  void setCategory(String value) => category.value = value;

  void addImageSlot() {
    if (!canAddImage) return;
    imageSlots.add(imageSlots.length);
  }

  void removeImageSlot(int index) {
    if (index < 0 || index >= imageSlots.length) return;
    imageSlots.removeAt(index);
  }

  Future<void> publish() async {
    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    final price = priceController.text.trim().replaceAll(r'$', '');
    if (name.isEmpty || description.isEmpty || price.isEmpty) {
      AppFlash.error('Fill name, description, and price to continue');
      return;
    }
    if (isPublishing.value) return;
    isPublishing.value = true;
    try {
      final amount = price.startsWith(r'$') ? price : '\$$price';
      final editing = isEditing;
      final id = editing
          ? editingServiceId.value
          : 'svc_${DateTime.now().millisecondsSinceEpoch}';

      PartnerService? existing;
      if (editing && Get.isRegistered<ServicesController>()) {
        for (final s in Get.find<ServicesController>().services) {
          if (s.id == id) {
            existing = s;
            break;
          }
        }
      }

      final service = PartnerService(
        id: id,
        title: name,
        category: category.value,
        description: description,
        priceLabel: '$amount · Starting From',
        isPublished: true,
        isBoosted: existing?.isBoosted ?? false,
        reviewStatus: editing
            ? (existing?.reviewStatus ?? PartnerServiceReviewStatus.pending)
            : PartnerServiceReviewStatus.pending,
        imageCount: imageSlots.length,
        rejectionReason: existing?.rejectionReason ??
            'You don’t have prior experience in this service.',
      );

      if (Get.isRegistered<ServicesController>()) {
        Get.find<ServicesController>().upsertService(service);
      }

      if (editing) {
        AppFlash.success('Service updated');
        Get.back();
        return;
      }

      final boost = await AppConfirmDialog.show(
        eyebrow: 'Published',
        title: 'Service Published Successfully',
        message:
            'Your service is now live and available for RSRVD members to discover.',
        confirmLabel: 'Boost Service',
        cancelLabel: 'View all Services',
        titleColor: AppColors.primary,
        barrierDismissible: false,
      );

      Get.until(
        (route) =>
            route.settings.name == AppRoutes.home || route.isFirst,
      );
      if (Get.isRegistered<MainShellController>()) {
        Get.find<MainShellController>().selectTab(MainTab.services.index);
      }

      if (boost == true) {
        Get.toNamed(
          AppRoutes.boostService,
          arguments: {'service_id': service.id},
        );
      } else {
        Get.toNamed(
          AppRoutes.serviceReviewStatus,
          arguments: service.id,
        );
      }
    } finally {
      isPublishing.value = false;
    }
  }

  void goBack() => Get.back();
}
