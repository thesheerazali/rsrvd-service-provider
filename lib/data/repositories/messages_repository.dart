import 'package:get/get.dart';

import '../../core/models/chat_message.dart';
import '../../core/models/messages_feed.dart';
import '../../core/models/partner_contract.dart';
import '../../core/services/app_log.dart';

/// Messages / chat data access — same shapes as Elite (`ConversationThread`,
/// `ChatMessage`, `ChatRichCard`) so the shared backend can serve both apps.
class MessagesRepository extends GetxService {
  static const String _tag = 'MESSAGES_REPO';

  /// Mutable thread message bags so Create Contract can append locally.
  final Map<String, List<Map<String, dynamic>>> _liveMessages = {};

  Future<MessagesFeed> fetchInbox() async {
    AppLog.i('fetchInbox (dummy)', tag: _tag);
    await Future<void>.delayed(const Duration(milliseconds: 60));
    return MessagesFeed.fromJson(_inboxPayload);
  }

  Future<ChatThreadDetail> fetchThread(String threadId) async {
    AppLog.i('fetchThread $threadId (dummy)', tag: _tag);
    await Future<void>.delayed(const Duration(milliseconds: 60));
    final map = Map<String, dynamic>.from(
      _threadPayloads[threadId] ?? _threadPayloads['thread_mk']!,
    );
    final live = _liveMessages[threadId];
    if (live != null) {
      map['messages'] = List<Map<String, dynamic>>.from(live);
    }
    return ChatThreadDetail.fromJson(map);
  }

  /// Append a text message (provider = `is_mine: true`).
  Future<ChatMessage> sendText({
    required String threadId,
    required String body,
  }) async {
    final messages = _ensureLive(threadId);
    final msg = {
      'id': 'local_${DateTime.now().millisecondsSinceEpoch}',
      'kind': 'text',
      'body': body,
      'time_label': 'Just now',
      'is_mine': true,
    };
    messages.add(msg);
    return ChatMessage.fromJson(msg);
  }

  /// Send a contract as a rich_card message — Elite receives the same shape.
  ///
  /// Status starts as `in_review` (Elite member sees Pay & Confirm).
  Future<ChatMessage> sendContract(PartnerContract contract) async {
    final threadId = contract.threadId;
    final messages = _ensureLive(threadId);
    final sent = contract.copyWith(status: PartnerContractStatus.inReview);
    final msg = {
      'id': 'contract_${sent.id}',
      'kind': 'rich_card',
      'body': '',
      'time_label': 'Just now',
      'is_mine': true,
      'contract_id': sent.id,
      'contract_status': sent.status.key,
      'rich_card': sent.toRichCard().toJson(),
    };
    messages.add(msg);
    AppLog.i('sendContract ${sent.id} → $threadId (in_review)', tag: _tag);
    return ChatMessage.fromJson(msg);
  }

  /// Simulates Elite member accepting the latest In Review contract.
  ///
  /// Backend equivalent: webhook / PATCH `contracts/:id` → `status: accepted`,
  /// then fan-out an updated `rich_card` on the thread (same message id).
  Future<ChatMessage?> simulateEliteAcceptContract(String threadId) async {
    final messages = _ensureLive(threadId);
    for (var i = messages.length - 1; i >= 0; i--) {
      final raw = messages[i];
      if (raw['kind'] != 'rich_card') continue;
      final card = Map<String, dynamic>.from(raw['rich_card'] as Map? ?? {});
      if ((card['status_label'] as String?) !=
          PartnerContractStatus.inReview.label) {
        continue;
      }
      card['status_label'] = PartnerContractStatus.accepted.label;
      card['status_tone'] = PartnerContractStatus.accepted.tone.name;
      card['cta_label'] = '';
      raw['rich_card'] = card;
      raw['contract_status'] = PartnerContractStatus.accepted.key;
      messages[i] = raw;

      // Elite member acknowledgement (same seed as Elite `thread_sp_accepted`).
      messages.add({
        'id': 'accept_${DateTime.now().millisecondsSinceEpoch}',
        'kind': 'text',
        'body': 'Accepted and paid. Excited to begin.',
        'time_label': 'Just now',
        'is_mine': false,
      });

      AppLog.i(
        'simulateEliteAccept ${raw['contract_id'] ?? raw['id']} → $threadId',
        tag: _tag,
      );
      return ChatMessage.fromJson(Map<String, dynamic>.from(raw));
    }
    return null;
  }

  /// Latest contract lifecycle on this thread (`null` if none sent).
  PartnerContractStatus? latestContractStatus(String threadId) {
    final messages = _liveMessages[threadId];
    if (messages == null) return null;
    for (var i = messages.length - 1; i >= 0; i--) {
      final raw = messages[i];
      if (raw['kind'] != 'rich_card') continue;
      final statusKey = raw['contract_status'] as String?;
      if (statusKey != null) {
        return PartnerContractStatusX.fromKey(statusKey);
      }
      final card = raw['rich_card'];
      if (card is! Map) continue;
      final label = card['status_label'] as String?;
      if (label == PartnerContractStatus.accepted.label) {
        return PartnerContractStatus.accepted;
      }
      if (label == PartnerContractStatus.inReview.label) {
        return PartnerContractStatus.inReview;
      }
      if (label == PartnerContractStatus.draft.label) {
        return PartnerContractStatus.draft;
      }
    }
    return null;
  }

  List<Map<String, dynamic>> _ensureLive(String threadId) {
    return _liveMessages.putIfAbsent(threadId, () {
      final seed = _threadPayloads[threadId] ?? _threadPayloads['thread_mk']!;
      final list = (seed['messages'] as List? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      return list;
    });
  }

  static final Map<String, dynamic> _inboxPayload = {
    'search_placeholder': 'Person, project or subject',
    'category_chips': [
      {'id': 'all', 'label': 'All'},
      {'id': 'unread', 'label': 'Unread'},
    ],
    'threads': [
      {
        'id': 'thread_mk',
        'subject': {
          'domain': 'service_providers',
          'entity_id': 'svc_arch_full',
          'category_label': 'Architect',
          'title': 'Full Architect Design',
          'meta_line': '\$20,000',
        },
        'counterpart_name': 'M. Kim',
        'counterpart_initials': 'MK',
        'preview': 'New Request',
        'time_label': 'Now',
        'status_label': '',
        'unread_count': 1,
        'desk_label': '',
      },
      {
        'id': 'thread_jw',
        'subject': {
          'domain': 'service_providers',
          'entity_id': 'svc_arch_palette',
          'category_label': 'Architect',
          'title': 'Material Palette Review',
          'meta_line': '',
        },
        'counterpart_name': 'J. Whitmore',
        'counterpart_initials': 'JW',
        'preview': 'Could you share the updated material palette this week?',
        'time_label': '2h',
        'status_label': '',
        'unread_count': 1,
        'desk_label': '',
      },
      {
        'id': 'thread_lt',
        'subject': {
          'domain': 'service_providers',
          'entity_id': 'svc_arch_meeting',
          'category_label': 'Project Architect',
          'title': 'Site Meeting',
          'meta_line': '',
        },
        'counterpart_name': 'L. Tan',
        'counterpart_initials': 'LT',
        'preview': 'Can you confirm the meeting time for next week?',
        'time_label': '10m',
        'status_label': '',
        'unread_count': 1,
        'desk_label': '',
      },
      {
        'id': 'thread_jw_2',
        'subject': {
          'domain': 'service_providers',
          'entity_id': 'svc_arch_palette_2',
          'category_label': 'Architect',
          'title': 'Material Palette Review',
          'meta_line': '',
        },
        'counterpart_name': 'J. Whitmore',
        'counterpart_initials': 'JW',
        'preview': 'Could you share the updated material palette this week?',
        'time_label': '2h',
        'status_label': '',
        'unread_count': 1,
        'desk_label': '',
      },
    ],
  };

  /// Provider-side seed: member messages are `is_mine: false`.
  static final Map<String, Map<String, dynamic>> _threadPayloads = {
    'thread_mk': {
      'thread': {
        'id': 'thread_mk',
        'subject': {
          'domain': 'service_providers',
          'entity_id': 'svc_arch_full',
          'category_label': 'Architect',
          'title': 'Full Architect Design',
          'meta_line': '\$20,000',
        },
        'counterpart_name': 'M. Kim',
        'counterpart_initials': 'MK',
        'preview': 'New Request',
        'time_label': 'Now',
        'unread_count': 1,
        'desk_label': '',
      },
      'messages': [
        {
          'id': 'm_mk_1',
          'kind': 'text',
          'body':
              'I need interior design work for my Miami property next month. Roughly 9,000 sq ft, currently shell condition.',
          'time_label': 'Today 11:52',
          'is_mine': false,
          'rich_card': {
            'domain_label': 'Architect',
            'title': 'Full Architect Design',
            'summary':
                'Concept through installation for primary and secondary residences.',
            'price_line': '\$50,000 · Starting From',
          },
        },
        {
          'id': 'm_mk_2',
          'body':
              'Yes, we can help. Please share the property details and any architectural drawings you have.',
          'time_label': 'Today 11:52',
          'is_mine': true,
        },
        {
          'id': 'm_mk_3',
          'body': 'Plans attached. Target completion before the season.',
          'time_label': 'Today 11:52',
          'is_mine': false,
        },
      ],
    },
    'thread_jw': {
      'thread': {
        'id': 'thread_jw',
        'subject': {
          'domain': 'service_providers',
          'entity_id': 'svc_arch_palette',
          'category_label': 'Architect',
          'title': 'Material Palette Review',
          'meta_line': '',
        },
        'counterpart_name': 'J. Whitmore',
        'counterpart_initials': 'JW',
        'preview': 'Could you share the updated material palette this week?',
        'time_label': '2h',
        'unread_count': 1,
        'desk_label': '',
      },
      'messages': [
        {
          'id': 'm_jw_1',
          'body': 'Could you share the updated material palette this week?',
          'time_label': 'Today 09:12',
          'is_mine': false,
        },
      ],
    },
    'thread_lt': {
      'thread': {
        'id': 'thread_lt',
        'subject': {
          'domain': 'service_providers',
          'entity_id': 'svc_arch_meeting',
          'category_label': 'Project Architect',
          'title': 'Site Meeting',
          'meta_line': '',
        },
        'counterpart_name': 'L. Tan',
        'counterpart_initials': 'LT',
        'preview': 'Can you confirm the meeting time for next week?',
        'time_label': '10m',
        'unread_count': 1,
        'desk_label': '',
      },
      'messages': [
        {
          'id': 'm_lt_1',
          'body': 'Can you confirm the meeting time for next week?',
          'time_label': 'Today 11:40',
          'is_mine': false,
        },
      ],
    },
    'thread_jw_2': {
      'thread': {
        'id': 'thread_jw_2',
        'subject': {
          'domain': 'service_providers',
          'entity_id': 'svc_arch_palette_2',
          'category_label': 'Architect',
          'title': 'Material Palette Review',
          'meta_line': '',
        },
        'counterpart_name': 'J. Whitmore',
        'counterpart_initials': 'JW',
        'preview': 'Could you share the updated material palette this week?',
        'time_label': '2h',
        'unread_count': 1,
        'desk_label': '',
      },
      'messages': [
        {
          'id': 'm_jw2_1',
          'body': 'Could you share the updated material palette this week?',
          'time_label': 'Yesterday',
          'is_mine': false,
        },
      ],
    },
  };
}
