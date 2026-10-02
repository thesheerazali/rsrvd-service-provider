import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../core/models/chat_message.dart';
import '../../core/models/conversation_thread.dart';
import '../../core/models/messages_feed.dart';
import '../../core/models/partner_contract.dart';
import '../../core/services/app_flash.dart';
import '../../core/services/app_log.dart';
import '../../data/repositories/messages_repository.dart';
import '../../routes/app_routes.dart';
import '../main_shell/main_shell_controller.dart';

class ChatDetailController extends GetxController {
  ChatDetailController({MessagesRepository? repository})
      : _repository = repository ?? Get.find<MessagesRepository>();

  final MessagesRepository _repository;
  static const String _tag = 'CHAT_DETAIL';

  final composerController = TextEditingController();
  final isLoading = true.obs;
  final thread = Rxn<ConversationThread>();
  final messages = <ChatMessage>[].obs;

  /// Latest contract on this thread — drives CTA + QA debug.
  final contractStatus = Rxn<PartnerContractStatus>();

  String get threadId {
    final args = Get.arguments;
    if (args is String) return args;
    if (args is Map && args['id'] is String) return args['id'] as String;
    return 'thread_mk';
  }

  bool get hasAcceptedContract =>
      contractStatus.value == PartnerContractStatus.accepted;

  bool get hasInReviewContract =>
      contractStatus.value == PartnerContractStatus.inReview;

  /// Show Create Contract until Elite accepts; then View In Projects.
  bool get showViewInProjects => hasAcceptedContract;

  bool get showDebugEliteAccept => kDebugMode && hasInReviewContract;

  @override
  void onInit() {
    super.onInit();
    loadThread();
  }

  @override
  void onClose() {
    final c = composerController;
    SchedulerBinding.instance.addPostFrameCallback((_) => c.dispose());
    super.onClose();
  }

  Future<void> loadThread() async {
    isLoading.value = true;
    try {
      final ChatThreadDetail detail = await _repository.fetchThread(threadId);
      thread.value = detail.thread;
      messages.assignAll(detail.messages);
      contractStatus.value = _repository.latestContractStatus(threadId) ??
          _statusFromMessages(detail.messages);
    } catch (e, st) {
      AppLog.e('loadThread failed: $e', tag: _tag, error: e, stackTrace: st);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final text = composerController.text.trim();
    if (text.isEmpty) return;
    composerController.clear();
    final msg = await _repository.sendText(threadId: threadId, body: text);
    messages.add(msg);
  }

  void attach() {
    AppFlash.info('Attachments land with the messaging API');
  }

  void onRichCardCta(ChatRichCard card) {
    AppFlash.info('${card.ctaLabel} — member action on Elite');
  }

  void onContractHeaderAction() {
    if (showViewInProjects) {
      openProjects();
    } else {
      openCreateContract();
    }
  }

  void openCreateContract() {
    final t = thread.value;
    if (t == null) return;
    Get.toNamed(
      AppRoutes.createContract,
      arguments: {
        'thread_id': t.id,
        'member_name': t.counterpartName,
        'category_label': t.subject.categoryLabel,
        'title_hint': t.subject.title,
      },
    )?.then((_) {
      loadThread();
    });
  }

  void openProjects() {
    Get.until(
      (route) =>
          route.settings.name == AppRoutes.home || route.isFirst,
    );
    if (Get.isRegistered<MainShellController>()) {
      Get.find<MainShellController>().selectTab(MainTab.projects.index);
    }
  }

  /// QA: pretend Elite member accepted + paid the In Review contract.
  Future<void> debugSimulateEliteAccept() async {
    final updated =
        await _repository.simulateEliteAcceptContract(threadId);
    if (updated == null) {
      AppFlash.info('No In Review contract on this thread');
      return;
    }
    await loadThread();
    AppFlash.success('Elite accepted — contract is Accepted');
  }

  void goBack() => Get.back();

  static PartnerContractStatus? _statusFromMessages(List<ChatMessage> items) {
    for (final m in items.reversed) {
      final card = m.richCard;
      if (card == null) continue;
      if (!card.domainLabel.toLowerCase().startsWith('contract')) continue;
      return switch (card.statusLabel) {
        'Accepted' => PartnerContractStatus.accepted,
        'In Review' => PartnerContractStatus.inReview,
        'Declined' => PartnerContractStatus.declined,
        'Draft' => PartnerContractStatus.draft,
        _ => null,
      };
    }
    return null;
  }
}
