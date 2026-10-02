import 'chat_message.dart';

/// Contract draft / offer created by a service provider and sent in chat.
///
/// Maps 1:1 onto [ChatRichCard] so Elite and Partners share the same
/// backend message payload (`kind: rich_card`).
///
/// Suggested API body when posting a contract message:
/// ```json
/// {
///   "kind": "rich_card",
///   "rich_card": { ...PartnerContract.toRichCard().toJson() }
/// }
/// ```
class PartnerContract {
  const PartnerContract({
    required this.id,
    required this.title,
    required this.categoryLabel,
    required this.scopeOfWork,
    required this.price,
    this.priceType = 'Fixed Price',
    this.scheduledAtLabel = '',
    this.location = '',
    this.attachmentLabel = '',
    this.status = PartnerContractStatus.draft,
    this.threadId = '',
    this.memberId = '',
  });

  final String id;
  final String title;

  /// Shown as `Contract · {category}` on the rich card.
  final String categoryLabel;
  final String scopeOfWork;

  /// Numeric amount without currency symbol, e.g. `20000`.
  final String price;
  final String priceType;

  /// Display line e.g. `Aug 2, 2026 · 10:00` (same as Elite `date_line`).
  final String scheduledAtLabel;
  final String location;
  final String attachmentLabel;
  final PartnerContractStatus status;

  /// Thread this contract belongs to (for append after send).
  final String threadId;
  final String memberId;

  String get domainLabel => 'Contract · $categoryLabel';

  String get priceLine {
    final amount = price.trim().isEmpty ? '0' : price.trim();
    final formatted = amount.startsWith(r'$') ? amount : '\$$amount';
    return '$formatted/$priceType';
  }

  /// Elite-aligned rich card for chat bubbles / contract preview.
  ChatRichCard toRichCard({String ctaLabel = ''}) {
    return ChatRichCard(
      domainLabel: domainLabel,
      title: title,
      summary: scopeOfWork,
      priceLine: priceLine,
      dateLine: scheduledAtLabel,
      location: location,
      attachmentLabel: attachmentLabel,
      statusLabel: status.label,
      statusTone: status.tone,
      ctaLabel: ctaLabel,
    );
  }

  factory PartnerContract.fromJson(Map<String, dynamic> json) {
    return PartnerContract(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      categoryLabel: json['category_label'] as String? ?? '',
      scopeOfWork: json['scope_of_work'] as String? ?? '',
      price: json['price'] as String? ?? '',
      priceType: json['price_type'] as String? ?? 'Fixed Price',
      scheduledAtLabel: json['scheduled_at_label'] as String? ?? '',
      location: json['location'] as String? ?? '',
      attachmentLabel: json['attachment_label'] as String? ?? '',
      status: PartnerContractStatusX.fromKey(json['status'] as String?),
      threadId: json['thread_id'] as String? ?? '',
      memberId: json['member_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category_label': categoryLabel,
        'scope_of_work': scopeOfWork,
        'price': price,
        'price_type': priceType,
        'scheduled_at_label': scheduledAtLabel,
        'location': location,
        'attachment_label': attachmentLabel,
        'status': status.key,
        'thread_id': threadId,
        'member_id': memberId,
      };

  PartnerContract copyWith({
    String? title,
    String? categoryLabel,
    String? scopeOfWork,
    String? price,
    String? priceType,
    String? scheduledAtLabel,
    String? location,
    String? attachmentLabel,
    PartnerContractStatus? status,
  }) {
    return PartnerContract(
      id: id,
      title: title ?? this.title,
      categoryLabel: categoryLabel ?? this.categoryLabel,
      scopeOfWork: scopeOfWork ?? this.scopeOfWork,
      price: price ?? this.price,
      priceType: priceType ?? this.priceType,
      scheduledAtLabel: scheduledAtLabel ?? this.scheduledAtLabel,
      location: location ?? this.location,
      attachmentLabel: attachmentLabel ?? this.attachmentLabel,
      status: status ?? this.status,
      threadId: threadId,
      memberId: memberId,
    );
  }
}

enum PartnerContractStatus { draft, inReview, accepted, declined }

extension PartnerContractStatusX on PartnerContractStatus {
  String get key => switch (this) {
        PartnerContractStatus.draft => 'draft',
        PartnerContractStatus.inReview => 'in_review',
        PartnerContractStatus.accepted => 'accepted',
        PartnerContractStatus.declined => 'declined',
      };

  String get label => switch (this) {
        PartnerContractStatus.draft => 'Draft',
        PartnerContractStatus.inReview => 'In Review',
        PartnerContractStatus.accepted => 'Accepted',
        PartnerContractStatus.declined => 'Declined',
      };

  ChatStatusTone get tone => switch (this) {
        PartnerContractStatus.draft => ChatStatusTone.muted,
        PartnerContractStatus.inReview => ChatStatusTone.review,
        PartnerContractStatus.accepted => ChatStatusTone.active,
        PartnerContractStatus.declined => ChatStatusTone.muted,
      };

  static PartnerContractStatus fromKey(String? raw) {
    return switch (raw) {
      'in_review' => PartnerContractStatus.inReview,
      'accepted' => PartnerContractStatus.accepted,
      'declined' => PartnerContractStatus.declined,
      _ => PartnerContractStatus.draft,
    };
  }
}
