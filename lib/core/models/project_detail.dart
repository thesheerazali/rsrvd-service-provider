import 'app_spec_row.dart';
import 'chat_message.dart';
import 'project_item.dart';

/// Completion handshake between Elite member and Service Provider apps.
///
/// Hardcoded SP debug states for now — API will settle Hold vs Held later.
enum ProjectCompletionStatus {
  none,

  /// Active + Contract Details + payment On Hold (Figma contract on-hold).
  paymentOnHold,

  /// Completed + awaiting banner + payment Held (Figma completed on-hold).
  providerMarkedComplete,

  memberApproved,
  issueRaised,
}

/// Module kind for Project Detail variants (Overview content differs per module).
enum ProjectModule {
  realEstate,
  investment,
  concierge,
  serviceProviders,
  events,
}

/// Contract block under Service Provider Overview (“CONTRACT DETAILS”).
class ProjectContractBlock {
  const ProjectContractBlock({
    required this.domainLabel,
    required this.title,
    required this.summary,
    required this.priceLine,
    required this.dateLine,
    required this.location,
    this.attachmentLabel = '',
    this.statusLabel = 'Active',
    this.statusTone = ProjectStatusTone.active,
  });

  final String domainLabel;
  final String title;
  final String summary;
  final String priceLine;
  final String dateLine;
  final String location;
  final String attachmentLabel;
  final String statusLabel;
  final ProjectStatusTone statusTone;

  factory ProjectContractBlock.fromJson(Map<String, dynamic> json) {
    return ProjectContractBlock(
      domainLabel: json['domain_label'] as String? ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      priceLine: json['price_line'] as String? ?? '',
      dateLine: json['date_line'] as String? ?? '',
      location: json['location'] as String? ?? '',
      attachmentLabel: json['attachment_label'] as String? ?? '',
      statusLabel: json['status_label'] as String? ?? 'Active',
      statusTone: _toneFrom(json['status_tone'] as String?),
    );
  }

  Map<String, dynamic> toJson() => {
        'domain_label': domainLabel,
        'title': title,
        'summary': summary,
        'price_line': priceLine,
        'date_line': dateLine,
        'location': location,
        'attachment_label': attachmentLabel,
        'status_label': statusLabel,
        'status_tone': statusTone.name,
      };

  /// Same payload shape Messages uses for contract rich cards.
  ChatRichCard toRichCard() {
    return ChatRichCard(
      domainLabel: domainLabel,
      title: title,
      summary: summary,
      priceLine: priceLine,
      dateLine: dateLine,
      location: location,
      attachmentLabel: attachmentLabel,
      statusLabel: statusLabel,
      statusTone: switch (statusTone) {
        ProjectStatusTone.muted => ChatStatusTone.muted,
        ProjectStatusTone.completed => ChatStatusTone.muted,
        ProjectStatusTone.cancelled => ChatStatusTone.muted,
        ProjectStatusTone.active => ChatStatusTone.active,
      },
    );
  }

  static ProjectStatusTone _toneFrom(String? raw) {
    return switch (raw) {
      'completed' => ProjectStatusTone.completed,
      'cancelled' => ProjectStatusTone.cancelled,
      'muted' => ProjectStatusTone.muted,
      _ => ProjectStatusTone.active,
    };
  }
}

/// Activity feed row under Project Detail → Activities.
class ProjectActivity {
  const ProjectActivity({
    required this.id,
    required this.body,
    required this.timeLabel,
  });

  final String id;
  final String body;
  final String timeLabel;

  factory ProjectActivity.fromJson(Map<String, dynamic> json) {
    return ProjectActivity(
      id: json['id'] as String? ?? '',
      body: json['body'] as String? ?? '',
      timeLabel: json['time_label'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'body': body,
        'time_label': timeLabel,
      };
}

/// Document row under Project Detail → Documents.
class ProjectDocument {
  const ProjectDocument({
    required this.id,
    required this.title,
    required this.meta,
    this.actionLabel = 'Review',
  });

  final String id;
  final String title;

  /// e.g. `PDF · 4.8 MB · 12 Jul`
  final String meta;
  final String actionLabel;

  factory ProjectDocument.fromJson(Map<String, dynamic> json) {
    return ProjectDocument(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      meta: json['meta'] as String? ?? '',
      actionLabel: json['action_label'] as String? ?? 'Review',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'meta': meta,
        'action_label': actionLabel,
      };
}

/// Payment card under Service Provider contract details.
class ProjectPaymentBlock {
  const ProjectPaymentBlock({
    required this.amountLabel,
    required this.note,
    this.statusLabel = 'Funded',
    this.statusTone = ProjectStatusTone.muted,
  });

  final String amountLabel;
  final String note;
  final String statusLabel;
  final ProjectStatusTone statusTone;

  factory ProjectPaymentBlock.fromJson(Map<String, dynamic> json) {
    return ProjectPaymentBlock(
      amountLabel: json['amount_label'] as String? ?? '',
      note: json['note'] as String? ?? '',
      statusLabel: json['status_label'] as String? ?? 'Funded',
      statusTone: switch (json['status_tone'] as String?) {
        'active' => ProjectStatusTone.active,
        'completed' => ProjectStatusTone.completed,
        'cancelled' => ProjectStatusTone.cancelled,
        _ => ProjectStatusTone.muted,
      },
    );
  }

  Map<String, dynamic> toJson() => {
        'amount_label': amountLabel,
        'note': note,
        'status_label': statusLabel,
        'status_tone': statusTone.name,
      };
}

/// Detail payload for Projects → Project Detail.
class ProjectDetail {
  const ProjectDetail({
    required this.id,
    required this.category,
    required this.title,
    required this.status,
    required this.statusTone,
    required this.module,
    required this.overviewRows,
    this.subtitle = '',
    this.adminNotes = '',
    this.attachmentLabel = '',
    this.ctaLabel = 'Chat with admin',
    this.secondaryCtaLabel = '',
    this.contractSectionTitle = '',
    this.issueNote = '',
    this.contract,
    this.payment,
    this.completionStatus = ProjectCompletionStatus.none,
    this.activities = const [],
    this.documents = const [],
    this.tabs = const ['Overview', 'Activities', 'Documents'],
  });

  final String id;
  final String category;
  final String title;

  /// e.g. provider name under the title (Service Provider).
  final String subtitle;
  final String status;
  final ProjectStatusTone statusTone;
  final ProjectModule module;
  final List<AppSpecRow> overviewRows;
  final String adminNotes;
  final String attachmentLabel;
  final String ctaLabel;

  /// e.g. `Mark Project as done` — empty hides secondary CTA.
  final String secondaryCtaLabel;
  final String contractSectionTitle;

  /// Member issue note shown on Partners Issue Raised detail.
  final String issueNote;
  final ProjectContractBlock? contract;
  final ProjectPaymentBlock? payment;

  /// Shared with Service Provider app — drives Approve / Raise-issue banner.
  final ProjectCompletionStatus completionStatus;
  final List<ProjectActivity> activities;
  final List<ProjectDocument> documents;
  final List<String> tabs;

  bool get hasSecondaryCta {
    if (secondaryCtaLabel.isEmpty) return false;
    return switch (completionStatus) {
      ProjectCompletionStatus.none ||
      ProjectCompletionStatus.memberApproved =>
        true,
      _ => false,
    };
  }

  /// Partners Figma: "Post an Update" only while actively working.
  bool get showPostUpdate =>
      completionStatus == ProjectCompletionStatus.none;

  bool get canCompleteProject =>
      completionStatus == ProjectCompletionStatus.none;

  bool get canCancelProject =>
      completionStatus == ProjectCompletionStatus.none;

  bool get showCompletionBanner =>
      completionStatus == ProjectCompletionStatus.providerMarkedComplete;

  bool get showIssueBanner =>
      completionStatus == ProjectCompletionStatus.issueRaised;

  bool get canResubmitCompletion =>
      completionStatus == ProjectCompletionStatus.issueRaised;

  /// Hold = Contract Details. Held / Issue / Active = specs only.
  bool get hasContractSection {
    if (completionStatus != ProjectCompletionStatus.paymentOnHold) {
      return false;
    }
    return contract != null ||
        payment != null ||
        contractSectionTitle.isNotEmpty;
  }

  ProjectDetail copyWith({
    ProjectCompletionStatus? completionStatus,
    String? secondaryCtaLabel,
    String? status,
    ProjectStatusTone? statusTone,
    String? issueNote,
  }) {
    return ProjectDetail(
      id: id,
      category: category,
      title: title,
      subtitle: subtitle,
      status: status ?? this.status,
      statusTone: statusTone ?? this.statusTone,
      module: module,
      overviewRows: overviewRows,
      adminNotes: adminNotes,
      attachmentLabel: attachmentLabel,
      ctaLabel: ctaLabel,
      secondaryCtaLabel: secondaryCtaLabel ?? this.secondaryCtaLabel,
      contractSectionTitle: contractSectionTitle,
      issueNote: issueNote ?? this.issueNote,
      contract: contract,
      payment: payment,
      completionStatus: completionStatus ?? this.completionStatus,
      activities: activities,
      documents: documents,
      tabs: tabs,
    );
  }

  factory ProjectDetail.fromJson(Map<String, dynamic> json) {
    return ProjectDetail(
      id: json['id'] as String? ?? '',
      category: json['category'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      status: json['status'] as String? ?? '',
      statusTone: switch (json['status_tone'] as String?) {
        'completed' => ProjectStatusTone.completed,
        'cancelled' => ProjectStatusTone.cancelled,
        'muted' => ProjectStatusTone.muted,
        _ => ProjectStatusTone.active,
      },
      module: _moduleFrom(json['module'] as String?),
      overviewRows: (json['overview_rows'] as List? ?? [])
          .map(
            (e) => AppSpecRow.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      adminNotes: json['admin_notes'] as String? ?? '',
      attachmentLabel: json['attachment_label'] as String? ?? '',
      ctaLabel: json['cta_label'] as String? ?? 'Chat with admin',
      secondaryCtaLabel: json['secondary_cta_label'] as String? ?? '',
      contractSectionTitle: json['contract_section_title'] as String? ?? '',
      issueNote: json['issue_note'] as String? ?? '',
      contract: json['contract'] is Map
          ? ProjectContractBlock.fromJson(
              Map<String, dynamic>.from(json['contract'] as Map),
            )
          : null,
      payment: json['payment'] is Map
          ? ProjectPaymentBlock.fromJson(
              Map<String, dynamic>.from(json['payment'] as Map),
            )
          : null,
      completionStatus: _completionFrom(json['completion_status'] as String?),
      activities: (json['activities'] as List? ?? [])
          .map(
            (e) =>
                ProjectActivity.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      documents: (json['documents'] as List? ?? [])
          .map(
            (e) =>
                ProjectDocument.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      tabs: (json['tabs'] as List?)?.cast<String>() ??
          const ['Overview', 'Activities', 'Documents'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'title': title,
        'subtitle': subtitle,
        'status': status,
        'status_tone': statusTone.name,
        'module': module.name,
        'overview_rows': overviewRows.map((e) => e.toJson()).toList(),
        'admin_notes': adminNotes,
        'attachment_label': attachmentLabel,
        'cta_label': ctaLabel,
        'secondary_cta_label': secondaryCtaLabel,
        'contract_section_title': contractSectionTitle,
        'issue_note': issueNote,
        if (contract != null) 'contract': contract!.toJson(),
        if (payment != null) 'payment': payment!.toJson(),
        'completion_status': switch (completionStatus) {
          ProjectCompletionStatus.paymentOnHold => 'payment_on_hold',
          ProjectCompletionStatus.providerMarkedComplete =>
            'provider_marked_complete',
          ProjectCompletionStatus.memberApproved => 'member_approved',
          ProjectCompletionStatus.issueRaised => 'issue_raised',
          ProjectCompletionStatus.none => 'none',
        },
        'activities': activities.map((e) => e.toJson()).toList(),
        'documents': documents.map((e) => e.toJson()).toList(),
        'tabs': tabs,
      };

  static ProjectModule _moduleFrom(String? raw) {
    return switch (raw) {
      'investment' => ProjectModule.investment,
      'concierge' => ProjectModule.concierge,
      'service_providers' => ProjectModule.serviceProviders,
      'events' => ProjectModule.events,
      _ => ProjectModule.realEstate,
    };
  }

  static ProjectCompletionStatus _completionFrom(String? raw) {
    return switch (raw) {
      'payment_on_hold' => ProjectCompletionStatus.paymentOnHold,
      'provider_marked_complete' =>
        ProjectCompletionStatus.providerMarkedComplete,
      'member_approved' => ProjectCompletionStatus.memberApproved,
      'issue_raised' => ProjectCompletionStatus.issueRaised,
      _ => ProjectCompletionStatus.none,
    };
  }
}
