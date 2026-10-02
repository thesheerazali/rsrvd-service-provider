import 'message_domain.dart';

/// The domain entity this conversation is about (property, fund, provider…).
///
/// Backend shape (suggested):
/// ```json
/// {
///   "domain": "investments",
///   "entity_id": "inv_skyline",
///   "category_label": "Investment",
///   "title": "Skyline Innovations",
///   "meta_line": "$250,000"
/// }
/// ```
class ChatSubject {
  const ChatSubject({
    required this.domain,
    required this.entityId,
    required this.categoryLabel,
    required this.title,
    this.metaLine = '',
  });

  final MessageDomain domain;

  /// Stable id of the linked record (property / investment / provider…).
  final String entityId;

  /// Short type label on the context card, e.g. `Investment`.
  final String categoryLabel;

  /// Entity display name.
  final String title;

  /// Secondary line — amount, status, date, etc.
  final String metaLine;

  /// Inbox eyebrow: `Investments · Aerospace Logistics Venture`.
  String get eyebrow => '${domain.label} · $title';

  factory ChatSubject.fromJson(Map<String, dynamic> json) {
    final domain = MessageDomainX.fromFilterKey(json['domain'] as String?) ??
        MessageDomain.investments;
    return ChatSubject(
      domain: domain,
      entityId: json['entity_id'] as String? ?? '',
      categoryLabel: json['category_label'] as String? ?? domain.label,
      title: json['title'] as String? ?? '',
      metaLine: json['meta_line'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'domain': domain.filterKey,
        'entity_id': entityId,
        'category_label': categoryLabel,
        'title': title,
        'meta_line': metaLine,
      };
}
