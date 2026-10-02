import 'chat_subject.dart';
import 'message_domain.dart';

/// One inbox row on Messages — Figma `1196:16358`.
class ConversationThread {
  const ConversationThread({
    required this.id,
    required this.subject,
    required this.counterpartName,
    required this.preview,
    required this.timeLabel,
    this.counterpartInitials = '',
    this.avatarUrl = '',
    this.statusLabel = '',
    this.unreadCount = 0,
    this.deskLabel = '',
  });

  final String id;
  final ChatSubject subject;

  /// Desk or person shown as the thread title (Cinzel).
  final String counterpartName;

  /// Initials when [avatarUrl] is empty (e.g. provider `AN`).
  final String counterpartInitials;

  /// Optional logo / photo URL (or asset path).
  final String avatarUrl;

  final String preview;
  final String timeLabel;

  /// e.g. `Project Created` — trailing status under preview.
  final String statusLabel;

  final int unreadCount;

  /// Chat header eyebrow — e.g. `Investments Desk`.
  final String deskLabel;

  MessageDomain get domain => subject.domain;

  String get filterKey => domain.filterKey;

  bool get hasUnread => unreadCount > 0;

  factory ConversationThread.fromJson(Map<String, dynamic> json) {
    return ConversationThread(
      id: json['id'] as String? ?? '',
      subject: ChatSubject.fromJson(
        Map<String, dynamic>.from(json['subject'] as Map? ?? {}),
      ),
      counterpartName: json['counterpart_name'] as String? ?? '',
      counterpartInitials: json['counterpart_initials'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
      preview: json['preview'] as String? ?? '',
      timeLabel: json['time_label'] as String? ?? '',
      statusLabel: json['status_label'] as String? ?? '',
      unreadCount: json['unread_count'] as int? ?? 0,
      deskLabel: json['desk_label'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': subject.toJson(),
        'counterpart_name': counterpartName,
        'counterpart_initials': counterpartInitials,
        'avatar_url': avatarUrl,
        'preview': preview,
        'time_label': timeLabel,
        'status_label': statusLabel,
        'unread_count': unreadCount,
        'desk_label': deskLabel,
      };

  ConversationThread copyWith({
    int? unreadCount,
    String? preview,
    String? timeLabel,
    String? statusLabel,
  }) {
    return ConversationThread(
      id: id,
      subject: subject,
      counterpartName: counterpartName,
      counterpartInitials: counterpartInitials,
      avatarUrl: avatarUrl,
      preview: preview ?? this.preview,
      timeLabel: timeLabel ?? this.timeLabel,
      statusLabel: statusLabel ?? this.statusLabel,
      unreadCount: unreadCount ?? this.unreadCount,
      deskLabel: deskLabel,
    );
  }
}
