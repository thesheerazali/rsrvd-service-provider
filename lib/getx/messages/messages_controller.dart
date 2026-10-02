import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../core/models/conversation_thread.dart';
import '../../core/services/app_flash.dart';
import '../../data/repositories/messages_repository.dart';
import '../../routes/app_routes.dart';
import '../main_shell/main_shell_controller.dart';

enum MessagesFilter { all, unread }

/// Messages / Chats tab — inbox uses Elite [ConversationThread] shape.
class MessagesController extends GetxController {
  MessagesController({MessagesRepository? repository})
      : _repository = repository ?? Get.find<MessagesRepository>();

  final MessagesRepository _repository;

  late final TextEditingController searchFieldController;

  final searchQuery = ''.obs;
  final filter = MessagesFilter.all.obs;
  final debugShowEmpty = false.obs;
  final threads = <ConversationThread>[].obs;
  final isLoading = false.obs;

  bool get showDebugToggle => kDebugMode;

  bool get showEmpty => debugShowEmpty.value || threads.isEmpty;

  List<ConversationThread> get visibleThreads {
    final q = searchQuery.value.trim().toLowerCase();
    return threads.where((t) {
      if (filter.value == MessagesFilter.unread && !t.hasUnread) {
        return false;
      }
      if (q.isEmpty) return true;
      return t.counterpartName.toLowerCase().contains(q) ||
          t.subject.categoryLabel.toLowerCase().contains(q) ||
          t.subject.title.toLowerCase().contains(q) ||
          t.preview.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    searchFieldController = TextEditingController();
    searchFieldController.addListener(() {
      searchQuery.value = searchFieldController.text;
    });
    loadInbox();
  }

  @override
  void onClose() {
    searchFieldController.dispose();
    super.onClose();
  }

  Future<void> loadInbox() async {
    isLoading.value = true;
    try {
      final feed = await _repository.fetchInbox();
      threads.assignAll(feed.threads);
    } finally {
      isLoading.value = false;
    }
  }

  void toggleDebugEmpty() => debugShowEmpty.toggle();

  void setFilter(MessagesFilter value) => filter.value = value;

  void onFilterTap() => AppFlash.info('coming_soon'.tr);

  void onThreadTap(ConversationThread thread) {
    Get.toNamed(AppRoutes.chatDetail, arguments: thread.id);
  }

  void onAddMoreServices() {
    if (Get.isRegistered<MainShellController>()) {
      Get.find<MainShellController>().selectTab(MainTab.services.index);
    }
  }
}
