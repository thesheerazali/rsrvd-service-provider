/// Visual tone for status pills on rich chat cards.
enum ChatStatusTone { active, review, muted }

/// Structured block inside a chat bubble.
///
/// Covers Investment continue (`1196:16542`), Real Estate (`1196:16780`),
/// Concierge (`1196:16857`), Events (`1196:16933`), and provider contract
/// offer / accepted (`1196:16620` / `1196:16698`).
class ChatRichCard {
  const ChatRichCard({
    required this.domainLabel,
    required this.title,
    this.location = '',
    this.tags = '',
    this.summary = '',
    this.attachmentLabel = '',
    this.statusLabel = '',
    this.statusTone = ChatStatusTone.active,
    this.priceLine = '',
    this.dateLine = '',
    this.ctaLabel = '',
    this.overlayLabel = '',
    this.footerLine = '',
  });

  /// Eyebrow — `Real Estate`, `Contract · Architect`, `Concierge Request`, `Event`.
  final String domainLabel;
  final String title;
  final String location;
  final String tags;
  final String summary;
  final String attachmentLabel;
  final String statusLabel;
  final ChatStatusTone statusTone;

  /// Highlighted amount inside the card (e.g. `$20000`).
  final String priceLine;

  /// e.g. `Aug 2, 2026 · 10:00`.
  final String dateLine;

  /// Primary action on the card — `Pay & Confirm`. Empty = no button.
  final String ctaLabel;

  /// Event outer chip — `02 Persons`.
  final String overlayLabel;

  /// Event footer — `$1200 · Zurich Switzerland`.
  final String footerLine;

  bool get hasCta => ctaLabel.isNotEmpty;

  bool get isEventLayout =>
      overlayLabel.isNotEmpty || footerLine.isNotEmpty;

  factory ChatRichCard.fromJson(Map<String, dynamic> json) {
    return ChatRichCard(
      domainLabel: json['domain_label'] as String? ?? '',
      title: json['title'] as String? ?? '',
      location: json['location'] as String? ?? '',
      tags: json['tags'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      attachmentLabel: json['attachment_label'] as String? ?? '',
      statusLabel: json['status_label'] as String? ?? '',
      statusTone: _toneFrom(json['status_tone'] as String?),
      priceLine: json['price_line'] as String? ?? '',
      dateLine: json['date_line'] as String? ?? '',
      ctaLabel: json['cta_label'] as String? ?? '',
      overlayLabel: json['overlay_label'] as String? ?? '',
      footerLine: json['footer_line'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'domain_label': domainLabel,
        'title': title,
        'location': location,
        'tags': tags,
        'summary': summary,
        'attachment_label': attachmentLabel,
        'status_label': statusLabel,
        'status_tone': statusTone.name,
        'price_line': priceLine,
        'date_line': dateLine,
        'cta_label': ctaLabel,
        'overlay_label': overlayLabel,
        'footer_line': footerLine,
      };

  static ChatStatusTone _toneFrom(String? raw) {
    return switch (raw) {
      'review' => ChatStatusTone.review,
      'muted' => ChatStatusTone.muted,
      _ => ChatStatusTone.active,
    };
  }
}

enum ChatMessageKind { text, richCard }

/// Single message in a thread — Figma chat frames under `1196:*`.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.body,
    required this.timeLabel,
    required this.isMine,
    this.kind = ChatMessageKind.text,
    this.emphasisSuffix = '',
    this.richCard,
  });

  final String id;
  final ChatMessageKind kind;

  /// Plain body (may include newlines).
  final String body;

  /// Optional bold trail shown after [body], e.g. `Indicative Amount: $20000`.
  final String emphasisSuffix;

  final String timeLabel;

  /// `true` = member (right-aligned); `false` = desk / counterpart (left).
  final bool isMine;

  final ChatRichCard? richCard;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final kindRaw = json['kind'] as String? ?? 'text';
    return ChatMessage(
      id: json['id'] as String? ?? '',
      kind: kindRaw == 'rich_card'
          ? ChatMessageKind.richCard
          : ChatMessageKind.text,
      body: json['body'] as String? ?? '',
      emphasisSuffix: json['emphasis_suffix'] as String? ?? '',
      timeLabel: json['time_label'] as String? ?? '',
      isMine: json['is_mine'] as bool? ?? false,
      richCard: json['rich_card'] is Map
          ? ChatRichCard.fromJson(
              Map<String, dynamic>.from(json['rich_card'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind == ChatMessageKind.richCard ? 'rich_card' : 'text',
        'body': body,
        'emphasis_suffix': emphasisSuffix,
        'time_label': timeLabel,
        'is_mine': isMine,
        if (richCard != null) 'rich_card': richCard!.toJson(),
      };
}
