import 'chat_message.dart';
import 'chat_subject.dart';
import 'conversation_thread.dart';

/// Inbox payload — Figma Messages `1196:16358`.
class MessagesFeed {
  const MessagesFeed({
    required this.searchPlaceholder,
    required this.categoryChips,
    required this.threads,
  });

  final String searchPlaceholder;
  final List<({String id, String label})> categoryChips;
  final List<ConversationThread> threads;

  factory MessagesFeed.fromJson(Map<String, dynamic> json) {
    final chips = (json['category_chips'] as List? ?? []).map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return (
        id: m['id'] as String? ?? '',
        label: m['label'] as String? ?? '',
      );
    }).toList();
    return MessagesFeed(
      searchPlaceholder:
          json['search_placeholder'] as String? ?? 'Person, project or subject',
      categoryChips: chips,
      threads: (json['threads'] as List? ?? [])
          .map(
            (e) => ConversationThread.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
    );
  }
}

/// Open thread payload — Figma Chat `1196:16468` (+ rich card `1196:16542`).
class ChatThreadDetail {
  const ChatThreadDetail({
    required this.thread,
    required this.messages,
  });

  final ConversationThread thread;
  final List<ChatMessage> messages;

  ChatSubject get subject => thread.subject;

  factory ChatThreadDetail.fromJson(Map<String, dynamic> json) {
    return ChatThreadDetail(
      thread: ConversationThread.fromJson(
        Map<String, dynamic>.from(json['thread'] as Map? ?? {}),
      ),
      messages: (json['messages'] as List? ?? [])
          .map(
            (e) => ChatMessage.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
    );
  }
}
