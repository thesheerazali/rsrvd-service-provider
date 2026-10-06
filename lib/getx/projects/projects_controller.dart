import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/models/app_filter_config.dart';
import '../../core/models/project_item.dart';
import '../../core/models/projects_feed.dart';
import '../../core/services/app_log.dart';
import '../../data/repositories/projects_repository.dart';
import '../../presentation/widgets/app_filter_dialog.dart';
import '../../routes/app_routes.dart';
import '../main_shell/main_shell_controller.dart';

class ProjectsController extends GetxController {
  ProjectsController({ProjectsRepository? repository})
      : _repository = repository ?? Get.find<ProjectsRepository>();

  final ProjectsRepository _repository;
  static const String _tag = 'PROJECTS';

  final searchController = TextEditingController();
  final isLoading = true.obs;
  final searchPlaceholder = ''.obs;
  final stageTabs = <String>[].obs;
  final projects = <ProjectItem>[].obs;
  final selectedStageIndex = 0.obs;
  final query = ''.obs;
  final debugShowEmpty = false.obs;
  final filterSelection = Rx<Map<String, Set<String>>>({});

  bool get showDebugToggle => kDebugMode;

  /// True only when the partner has no projects at all (or debug force).
  bool get showEmpty =>
      debugShowEmpty.value || (!isLoading.value && projects.isEmpty);

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() => query.value = searchController.text);
    loadFeed();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadFeed() async {
    isLoading.value = true;
    try {
      final ProjectsFeed feed = await _repository.fetchProjectsFeed();
      searchPlaceholder.value = feed.searchPlaceholder;
      stageTabs.assignAll(feed.stageTabs);
      projects.assignAll(feed.projects);
    } catch (e, st) {
      AppLog.e('loadFeed failed: $e', tag: _tag, error: e, stackTrace: st);
    } finally {
      isLoading.value = false;
    }
  }

  void selectStage(int index) => selectedStageIndex.value = index;

  void toggleDebugEmpty() => debugShowEmpty.toggle();

  Future<void> openFilters() async {
    final result = await AppFilterDialog.show(
      config: AppFilterConfig.projects,
      initial: filterSelection.value,
    );
    if (result == null) return;
    filterSelection.value = Map<String, Set<String>>.from(result);
    final status = result['status'] ?? {};
    if (status.contains('completed')) {
      selectedStageIndex.value = 1;
    } else if (status.contains('active')) {
      selectedStageIndex.value = 0;
    }
  }

  List<ProjectItem> get filteredProjects {
    final stage = switch (selectedStageIndex.value) {
      1 => ProjectStage.completed,
      2 => ProjectStage.cancelled,
      _ => ProjectStage.active,
    };
    final q = query.value.trim().toLowerCase();
    return projects.where((p) {
      if (p.stage != stage) return false;
      if (q.isEmpty) return true;
      return p.title.toLowerCase().contains(q) ||
          p.counterpartName.toLowerCase().contains(q) ||
          p.amountLabel.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
    }).toList();
  }

  void openProject(ProjectItem item) {
    Get.toNamed(AppRoutes.projectDetail, arguments: {'id': item.id});
  }

  void onViewMessages() {
    if (Get.isRegistered<MainShellController>()) {
      Get.find<MainShellController>().selectTab(MainTab.chats.index);
    }
  }
}
