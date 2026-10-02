import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../core/models/partner_contract.dart';
import '../../core/services/app_flash.dart';
import '../../data/repositories/messages_repository.dart';
import '../../routes/app_routes.dart';
import '../chat_detail/chat_detail_controller.dart';

class CreateContractController extends GetxController {
  CreateContractController({MessagesRepository? repository})
      : _repository = repository ?? Get.find<MessagesRepository>();

  final MessagesRepository _repository;

  late final TextEditingController titleController;
  late final TextEditingController scopeController;
  late final TextEditingController priceController;
  late final TextEditingController dateController;
  late final TextEditingController timeController;
  late final TextEditingController locationController;

  final categoryLabel = 'Architect'.obs;
  final attachmentLabel = ''.obs;
  final isSending = false.obs;

  final categories = const [
    'Architect',
    'Interior Design',
    'Landscape',
    'Project Architect',
  ];

  String get threadId {
    final args = Get.arguments;
    if (args is Map && args['thread_id'] is String) {
      return args['thread_id'] as String;
    }
    return 'thread_mk';
  }

  String get memberName {
    final args = Get.arguments;
    if (args is Map && args['member_name'] is String) {
      return args['member_name'] as String;
    }
    return 'Member';
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    final titleHint = args is Map ? (args['title_hint'] as String? ?? '') : '';
    final cat = args is Map ? (args['category_label'] as String? ?? '') : '';
    if (cat.isNotEmpty) categoryLabel.value = cat;

    titleController = TextEditingController(text: titleHint);
    scopeController = TextEditingController();
    priceController = TextEditingController();
    dateController = TextEditingController(text: 'Aug 2, 2026');
    timeController = TextEditingController(text: '10:00');
    locationController = TextEditingController(
      text: '16 Tüffenwies, Zurich, District Zurich, 8064, Switzerland',
    );
  }

  @override
  void onClose() {
    final controllers = [
      titleController,
      scopeController,
      priceController,
      dateController,
      timeController,
      locationController,
    ];
    SchedulerBinding.instance.addPostFrameCallback((_) {
      for (final c in controllers) {
        c.dispose();
      }
    });
    super.onClose();
  }

  void setCategory(String value) => categoryLabel.value = value;

  void attachDocument() {
    attachmentLabel.value = 'Scope_appendix.pdf';
    AppFlash.success('Document attached (demo)');
  }

  void removeAttachment() => attachmentLabel.value = '';

  PartnerContract buildDraft({
    PartnerContractStatus status = PartnerContractStatus.draft,
  }) {
    final date = dateController.text.trim();
    final time = timeController.text.trim();
    final scheduled = [date, time].where((e) => e.isNotEmpty).join(' · ');
    return PartnerContract(
      id: 'pc_${DateTime.now().millisecondsSinceEpoch}',
      title: titleController.text.trim().isEmpty
          ? 'Untitled Contract'
          : titleController.text.trim(),
      categoryLabel: categoryLabel.value,
      scopeOfWork: scopeController.text.trim(),
      price: priceController.text.trim().replaceAll(r'$', ''),
      scheduledAtLabel: scheduled,
      location: locationController.text.trim(),
      attachmentLabel: attachmentLabel.value,
      status: status,
      threadId: threadId,
    );
  }

  void previewContract() {
    final title = titleController.text.trim();
    final scope = scopeController.text.trim();
    final price = priceController.text.trim();
    if (title.isEmpty || scope.isEmpty || price.isEmpty) {
      AppFlash.error('Fill title, scope, and price to continue');
      return;
    }
    Get.toNamed(
      AppRoutes.contractPreview,
      arguments: buildDraft(),
    );
  }

  Future<void> sendContract(PartnerContract draft) async {
    if (isSending.value) return;
    isSending.value = true;
    try {
      await _repository.sendContract(draft);
      AppFlash.success('Contract sent');
      Get.until((route) => route.settings.name == AppRoutes.chatDetail);
      if (Get.isRegistered<ChatDetailController>()) {
        await Get.find<ChatDetailController>().loadThread();
      }
    } finally {
      isSending.value = false;
    }
  }

  void goBack() => Get.back();
}
