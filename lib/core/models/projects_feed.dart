import 'project_item.dart';

/// Projects tab payload — swap dummy JSON for API later.
class ProjectsFeed {
  const ProjectsFeed({
    required this.searchPlaceholder,
    required this.stageTabs,
    required this.categoryChips,
    required this.projects,
  });

  final String searchPlaceholder;
  final List<String> stageTabs;
  final List<({String id, String label})> categoryChips;
  final List<ProjectItem> projects;

  factory ProjectsFeed.fromJson(Map<String, dynamic> json) {
    final chips = (json['category_chips'] as List? ?? []).map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return (id: m['id'] as String? ?? '', label: m['label'] as String? ?? '');
    }).toList();

    return ProjectsFeed(
      searchPlaceholder: json['search_placeholder'] as String? ?? '',
      stageTabs: (json['stage_tabs'] as List? ?? [])
          .map((e) => e as String)
          .toList(),
      categoryChips: chips,
      projects: (json['projects'] as List? ?? [])
          .map((e) => ProjectItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}
