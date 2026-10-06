import 'package:get/get.dart';

import '../../core/models/project_detail.dart';
import '../../core/models/projects_feed.dart';
import '../../core/services/app_log.dart';

/// Partners Projects — same shapes as Elite (`ProjectItem`, `ProjectDetail`)
/// so accepted contracts become projects on both apps.
class ProjectsRepository extends GetxService {
  static const String _tag = 'PROJECTS_REPO';

  /// Live completion overrides for QA / mark-complete demo.
  final Map<String, Map<String, dynamic>> _detailOverrides = {};

  Future<ProjectsFeed> fetchProjectsFeed() async {
    AppLog.i('fetchProjectsFeed (dummy)', tag: _tag);
    await Future<void>.delayed(const Duration(milliseconds: 60));
    return ProjectsFeed.fromJson(_feedPayload);
  }

  Future<ProjectDetail> fetchProjectDetail(String id) async {
    AppLog.i('fetchProjectDetail $id (dummy)', tag: _tag);
    await Future<void>.delayed(const Duration(milliseconds: 60));
    final base = Map<String, dynamic>.from(
      _details[id] ?? _details['proj_mk']!,
    );
    final override = _detailOverrides[id];
    if (override != null) {
      base.addAll(override);
    }
    base.putIfAbsent('activities', () => _sampleActivities);
    base.putIfAbsent('documents', () => _sampleDocuments);
    return ProjectDetail.fromJson(base);
  }

  /// SP marks project complete → Completed + Held + awaiting member (Figma).
  Future<ProjectDetail> markProjectComplete(String id) async {
    _detailOverrides[id] = {
      'completion_status': 'provider_marked_complete',
      'status': 'Completed',
      'status_tone': 'completed',
      'secondary_cta_label': '',
      'overview_rows': _heldOverviewRowsFor(id),
    };
    AppLog.i('markProjectComplete $id → provider_marked_complete', tag: _tag);
    return fetchProjectDetail(id);
  }

  /// QA: simulate Elite member approved / issue raised / reset.
  Future<ProjectDetail> debugSetCompletion(
    String id,
    ProjectCompletionStatus status,
  ) async {
    _detailOverrides[id] = switch (status) {
      ProjectCompletionStatus.none => {
          'completion_status': 'none',
          'status': 'Active',
          'status_tone': 'active',
          'secondary_cta_label': 'Complete Project',
          'issue_note': '',
          'overview_rows': _activeOverviewRowsFor(id),
        },
      // Hardcoded Hold — Active + Contract Details (API later).
      ProjectCompletionStatus.paymentOnHold => {
          'completion_status': 'payment_on_hold',
          'status': 'Active',
          'status_tone': 'active',
          'secondary_cta_label': '',
          'issue_note': '',
          'overview_rows': _onHoldOverviewRowsFor(id),
        },
      // Hardcoded Held — Completed + awaiting banner (API later).
      ProjectCompletionStatus.providerMarkedComplete => {
          'completion_status': 'provider_marked_complete',
          'status': 'Completed',
          'status_tone': 'completed',
          'secondary_cta_label': '',
          'issue_note': '',
          'overview_rows': _heldOverviewRowsFor(id),
        },
      ProjectCompletionStatus.memberApproved => {
          'completion_status': 'member_approved',
          'status': 'Completed',
          'status_tone': 'completed',
          'secondary_cta_label': '',
          'issue_note': '',
        },
      ProjectCompletionStatus.issueRaised => {
          'completion_status': 'issue_raised',
          'status': 'Issue Raised',
          'status_tone': 'muted',
          'secondary_cta_label': 'Resubmit Completion',
          'issue_note':
              'The lighting package in the primary suite is incomplete.',
          'overview_rows': _issueOverviewRowsFor(id),
        },
    };
    return fetchProjectDetail(id);
  }

  List<Map<String, dynamic>> _activeOverviewRowsFor(String id) {
    final base = _details[id] ?? _details['proj_mk']!;
    final rows = (base['overview_rows'] as List? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    for (final row in rows) {
      if (row['label'] == 'Payment status') row['value'] = 'Funded';
    }
    return rows.where((r) => r['label'] != 'Current Stage').toList();
  }

  /// Hold — payment label "On Hold" (Active + contract section).
  List<Map<String, dynamic>> _onHoldOverviewRowsFor(String id) {
    final rows = _activeOverviewRowsFor(id);
    for (final row in rows) {
      if (row['label'] == 'Payment status') row['value'] = 'On Hold';
    }
    return rows;
  }

  /// Held — payment label "Held" (Completed + awaiting confirmation).
  List<Map<String, dynamic>> _heldOverviewRowsFor(String id) {
    final rows = _activeOverviewRowsFor(id);
    for (final row in rows) {
      if (row['label'] == 'Payment status') row['value'] = 'Held';
    }
    return rows;
  }

  List<Map<String, dynamic>> _issueOverviewRowsFor(String id) {
    final rows = _heldOverviewRowsFor(id);
    return [
      {'label': 'Current Stage', 'value': 'Completed'},
      ...rows,
    ];
  }

  static final List<Map<String, dynamic>> _sampleActivities = [
    {
      'id': 'act_1',
      'body': 'Documents uploaded — Concept_Deck_v2.pdf',
      'time_label': '2h ago',
    },
    {
      'id': 'act_2',
      'body': 'Payment confirmed and held by RSRVD',
      'time_label': '1d ago',
    },
    {
      'id': 'act_3',
      'body': 'Contract accepted by member',
      'time_label': '2d ago',
    },
  ];

  static final List<Map<String, dynamic>> _sampleDocuments = [
    {
      'id': 'doc_1',
      'title': 'Scope_appendix.pdf',
      'meta': 'PDF · 2.4 MB · 2 Aug',
      'action_label': 'Review',
    },
    {
      'id': 'doc_2',
      'title': 'Concept_Deck_v2.pdf',
      'meta': 'PDF · 4.8 MB · Today',
      'action_label': 'Review',
    },
  ];

  /// Partners feed — Figma `1196:4121` (+ empty `1196:4039`).
  static final Map<String, dynamic> _feedPayload = {
    'search_placeholder': 'Name or reference...',
    'stage_tabs': ['Active', 'Completed', 'Cancelled'],
    'category_chips': [
      {'id': 'all', 'label': 'All'},
    ],
    'projects': [
      {
        'id': 'proj_mk',
        'category': 'Architect',
        'title': 'Full Architect Design',
        'status': 'Active',
        'status_tone': 'active',
        'detail': '',
        'stage': 'active',
        'category_filter': 'service_providers',
        'counterpart_name': 'M. Kim',
        'amount_label': r'$20,000',
        'meta_line': 'Started Aug 3, 2026 · Updated 1d',
      },
      {
        'id': 'proj_at',
        'category': 'Architect',
        'title': 'Riverside Park',
        'status': 'Active',
        'status_tone': 'active',
        'detail': '',
        'stage': 'active',
        'category_filter': 'service_providers',
        'counterpart_name': 'A. Thompson',
        'amount_label': r'$250,000',
        'meta_line': 'Started Sep 15, 2026 · Updated 2d',
      },
      {
        'id': 'proj_jw',
        'category': 'Architect',
        'title': 'Indian Creek Residence Design',
        'status': 'Active',
        'status_tone': 'active',
        'detail': '',
        'stage': 'active',
        'category_filter': 'service_providers',
        'counterpart_name': 'J. Whitmore',
        'amount_label': r'$150,000',
        'meta_line': 'Started Aug 3, 2026 · Updated 1d',
      },
      {
        'id': 'proj_mk_done',
        'category': 'Architect',
        'title': 'Full Architect Design',
        'status': 'Completed',
        'status_tone': 'completed',
        'detail': '',
        'stage': 'completed',
        'category_filter': 'service_providers',
        'counterpart_name': 'M. Kim',
        'amount_label': r'$20,000',
        'meta_line': 'Started Aug 3, 2026 · Updated 5d',
      },
    ],
  };

  static final Map<String, Map<String, dynamic>> _details = {
    'proj_mk': {
      'id': 'proj_mk',
      'category': 'Architect',
      'title': 'Full Architect Design',
      'subtitle': 'M. Kim',
      'status': 'Active',
      'status_tone': 'active',
      'module': 'service_providers',
      'overview_rows': [
        {'label': 'Start date', 'value': 'Aug 02, 2026'},
        {'label': 'Expected completion', 'value': 'Sept 08, 2026'},
        {'label': 'Contract Amount', 'value': r'$20,000'},
        {'label': 'Payment status', 'value': 'Funded'},
        {
          'label': 'Location',
          'value':
              '16 Tüffenwies, Zurich, District Zurich, 8064, Switzerland',
        },
      ],
      'cta_label': 'Chat with Member',
      'secondary_cta_label': 'Complete Project',
      'completion_status': 'none',
      'contract_section_title': 'Contract Details',
      'contract': {
        'domain_label': 'Contract · Architect',
        'title': 'Full Architect Design',
        'summary':
            'Full design commission for a 9,000 sq ft residence: concept, '
                'space planning, millwork packages, FF&E procurement, art '
                'curation and installation supervision.',
        'price_line': r'$20000/Fixed Price',
        'date_line': 'Aug 2, 2026 · 10:00',
        'location':
            '16 Tüffenwies, Zurich, District Zurich, 8064, Switzerland',
        'attachment_label': 'Scope_appendix.pdf',
        'status_label': 'Active',
        'status_tone': 'active',
      },
      'payment': {
        'amount_label': r'$20,000',
        'note':
            'Member payments are secured by RSRVD. Payment status updates '
                'automatically — you never mark a payment as received.',
        'status_label': 'Funded',
        'status_tone': 'muted',
      },
      'tabs': ['Overview', 'Activities', 'Documents'],
    },
    'proj_at': {
      'id': 'proj_at',
      'category': 'Architect',
      'title': 'Riverside Park',
      'subtitle': 'A. Thompson',
      'status': 'Active',
      'status_tone': 'active',
      'module': 'service_providers',
      'overview_rows': [
        {'label': 'Start date', 'value': 'Sep 15, 2026'},
        {'label': 'Expected completion', 'value': 'Nov 01, 2026'},
        {'label': 'Contract Amount', 'value': r'$250,000'},
        {'label': 'Payment status', 'value': 'Funded'},
        {
          'label': 'Location',
          'value': 'Riverside Park, Miami',
        },
      ],
      'cta_label': 'Chat with Member',
      'secondary_cta_label': 'Complete Project',
      'completion_status': 'none',
      'contract_section_title': 'Contract Details',
      'contract': {
        'domain_label': 'Contract · Architect',
        'title': 'Riverside Park',
        'summary': 'Landscape and architecture package for riverside estate.',
        'price_line': r'$250000/Fixed Price',
        'date_line': 'Sep 15, 2026 · 10:00',
        'location': 'Riverside Park, Miami',
        'attachment_label': '',
        'status_label': 'Active',
        'status_tone': 'active',
      },
      'payment': {
        'amount_label': r'$250,000',
        'note':
            'Member payments are secured by RSRVD. Payment status updates '
                'automatically — you never mark a payment as received.',
        'status_label': 'Funded',
        'status_tone': 'muted',
      },
      'tabs': ['Overview', 'Activities', 'Documents'],
    },
    'proj_jw': {
      'id': 'proj_jw',
      'category': 'Architect',
      'title': 'Indian Creek Residence Design',
      'subtitle': 'J. Whitmore',
      'status': 'Active',
      'status_tone': 'active',
      'module': 'service_providers',
      'overview_rows': [
        {'label': 'Start date', 'value': 'Aug 03, 2026'},
        {'label': 'Expected completion', 'value': 'Oct 15, 2026'},
        {'label': 'Contract Amount', 'value': r'$150,000'},
        {'label': 'Payment status', 'value': 'Funded'},
      ],
      'cta_label': 'Chat with Member',
      'secondary_cta_label': 'Complete Project',
      'completion_status': 'none',
      'contract_section_title': 'Contract Details',
      'contract': {
        'domain_label': 'Contract · Architect',
        'title': 'Indian Creek Residence Design',
        'summary': 'Full residence design package for Indian Creek.',
        'price_line': r'$150000/Fixed Price',
        'date_line': 'Aug 3, 2026 · 10:00',
        'location': 'Indian Creek, Miami',
        'attachment_label': '',
        'status_label': 'Active',
        'status_tone': 'active',
      },
      'payment': {
        'amount_label': r'$150,000',
        'note':
            'Member payments are secured by RSRVD. Payment status updates '
                'automatically — you never mark a payment as received.',
        'status_label': 'Funded',
        'status_tone': 'muted',
      },
      'tabs': ['Overview', 'Activities', 'Documents'],
    },
    'proj_mk_done': {
      'id': 'proj_mk_done',
      'category': 'Architect',
      'title': 'Full Architect Design',
      'subtitle': 'M. Kim',
      'status': 'Completed',
      'status_tone': 'completed',
      'module': 'service_providers',
      'overview_rows': [
        {'label': 'Start date', 'value': 'Aug 02, 2026'},
        {'label': 'Completed', 'value': 'Sept 01, 2026'},
        {'label': 'Contract Amount', 'value': r'$20,000'},
        {'label': 'Payment status', 'value': 'Released'},
      ],
      'cta_label': 'Chat with Member',
      'secondary_cta_label': '',
      'completion_status': 'member_approved',
      'contract_section_title': 'Contract Details',
      'contract': {
        'domain_label': 'Contract · Architect',
        'title': 'Full Architect Design',
        'summary':
            'Full design commission for a 9,000 sq ft residence: concept, '
                'space planning, millwork packages, FF&E procurement, art '
                'curation and installation supervision.',
        'price_line': r'$20000/Fixed Price',
        'date_line': 'Aug 2, 2026 · 10:00',
        'location':
            '16 Tüffenwies, Zurich, District Zurich, 8064, Switzerland',
        'attachment_label': 'Scope_appendix.pdf',
        'status_label': 'Accepted',
        'status_tone': 'active',
      },
      'payment': {
        'amount_label': r'$20,000',
        'note':
            'Member payments are secured by RSRVD. Payment status updates '
                'automatically — you never mark a payment as received.',
        'status_label': 'Released',
        'status_tone': 'active',
      },
      'tabs': ['Overview', 'Activities', 'Documents'],
    },
  };
}
