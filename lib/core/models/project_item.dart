/// Project lifecycle stage — top tabs on Projects (Figma `1196:4038`).
enum ProjectStage { active, completed, cancelled }

/// Visual tone for the status pill.
enum ProjectStatusTone { active, completed, muted, cancelled }

/// Full project card — shared with Elite; Partners list also uses
/// [counterpartName] / [amountLabel] / [metaLine] (Figma `1196:4121`).
class ProjectItem {
  const ProjectItem({
    required this.id,
    required this.category,
    required this.title,
    required this.status,
    required this.statusTone,
    required this.detail,
    required this.stage,
    required this.categoryFilter,
    this.progress,
    this.progressLabel,
    this.faded = false,
    this.elevated = false,
    this.counterpartName = '',
    this.amountLabel = '',
    this.metaLine = '',
  });

  final String id;
  final String category;
  final String title;
  final String status;
  final ProjectStatusTone statusTone;
  final String detail;
  final ProjectStage stage;

  /// Chip filter key, e.g. `service_providers` (shared with Elite).
  final String categoryFilter;

  final int? progress;
  final String? progressLabel;
  final bool faded;
  final bool elevated;

  /// Elite member name on Partners list cards — e.g. `M. Kim`.
  final String counterpartName;

  /// e.g. `$20,000`
  final String amountLabel;

  /// e.g. `Started Aug 3, 2026 · Updated 1d`
  final String metaLine;

  factory ProjectItem.fromJson(Map<String, dynamic> json) {
    return ProjectItem(
      id: json['id'] as String? ?? '',
      category: json['category'] as String? ?? '',
      title: json['title'] as String? ?? '',
      status: json['status'] as String? ?? '',
      statusTone: _toneFrom(json['status_tone'] as String?),
      detail: json['detail'] as String? ?? '',
      stage: _stageFrom(json['stage'] as String?),
      categoryFilter: json['category_filter'] as String? ?? 'service_providers',
      progress: json['progress'] as int?,
      progressLabel: json['progress_label'] as String?,
      faded: json['faded'] as bool? ?? false,
      elevated: json['elevated'] as bool? ?? false,
      counterpartName: json['counterpart_name'] as String? ?? '',
      amountLabel: json['amount_label'] as String? ?? '',
      metaLine: json['meta_line'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'title': title,
        'status': status,
        'status_tone': statusTone.name,
        'detail': detail,
        'stage': stage.name,
        'category_filter': categoryFilter,
        'progress': progress,
        'progress_label': progressLabel,
        'faded': faded,
        'elevated': elevated,
        'counterpart_name': counterpartName,
        'amount_label': amountLabel,
        'meta_line': metaLine,
      };

  static ProjectStage _stageFrom(String? raw) {
    return switch (raw) {
      'completed' => ProjectStage.completed,
      'cancelled' => ProjectStage.cancelled,
      _ => ProjectStage.active,
    };
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
