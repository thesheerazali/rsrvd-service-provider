import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/models/project_detail.dart';
import '../../core/services/app_flash.dart';
import '../../core/services/app_log.dart';
import '../../data/repositories/projects_repository.dart';
import '../../presentation/widgets/app_confirm_dialog.dart';
import '../../routes/app_routes.dart';
import '../main_shell/main_shell_controller.dart';

class ProjectDetailController extends GetxController {
  ProjectDetailController({ProjectsRepository? repository})
      : _repository = repository ?? Get.find<ProjectsRepository>();

  final ProjectsRepository _repository;
  static const String _tag = 'PROJECT_DETAIL';

  final isLoading = true.obs;
  final detail = Rxn<ProjectDetail>();
  final selectedTabIndex = 0.obs;
  final updateController = TextEditingController();

  bool get showDebugToggles => kDebugMode;

  String get projectId {
    final args = Get.arguments;
    if (args is String) return args;
    if (args is Map && args['id'] is String) return args['id'] as String;
    return 'proj_mk';
  }

  @override
  void onInit() {
    super.onInit();
    loadDetail();
  }

  @override
  void onClose() {
    updateController.dispose();
    super.onClose();
  }

  Future<void> loadDetail() async {
    isLoading.value = true;
    try {
      detail.value = await _repository.fetchProjectDetail(projectId);
      selectedTabIndex.value = 0;
    } catch (e, st) {
      AppLog.e('loadDetail failed: $e', tag: _tag, error: e, stackTrace: st);
    } finally {
      isLoading.value = false;
    }
  }

  void selectTab(int index) => selectedTabIndex.value = index;

  void chatWithMember() {
    Get.until(
      (route) => route.settings.name == AppRoutes.home || route.isFirst,
    );
    if (Get.isRegistered<MainShellController>()) {
      Get.find<MainShellController>().selectTab(MainTab.chats.index);
    }
  }

  void reviewDocument(ProjectDocument doc) {
    AppFlash.info('${doc.title} — opens when document viewer lands');
  }

  void postUpdate() {
    final text = updateController.text.trim();
    if (text.isEmpty) {
      AppFlash.info('Add a short progress note first');
      return;
    }
    updateController.clear();
    AppFlash.success('Update posted');
  }

  /// Partners marks complete → Completed + Held + awaiting member.
  Future<void> completeProject() async {
    final updated = await _repository.markProjectComplete(projectId);
    detail.value = updated;
    AppFlash.success('Marked complete — payment on hold until member confirms');
  }

  Future<void> resubmitCompletion() async {
    final updated = await _repository.markProjectComplete(projectId);
    detail.value = updated;
    AppFlash.success('Completion resubmitted — awaiting member confirmation');
  }

  Future<void> cancelProject() async {
    final confirmed = await AppConfirmDialog.show(
      eyebrow: 'Cancel Project',
      title: 'Cancel this project?',
      message:
          'This engagement will move to Cancelled. You can still chat with '
          'the member about next steps.',
      confirmLabel: 'Cancel Project',
      cancelLabel: 'Keep Project',
    );
    if (confirmed != true) return;
    AppFlash.info('Cancel flow lands with API');
  }

  Future<void> debugSetCompletion(ProjectCompletionStatus status) async {
    detail.value = await _repository.debugSetCompletion(projectId, status);
  }

  void goBack() => Get.back();
}
