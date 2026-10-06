/// Shared label / value row for detail specs cards (property, investment, etc.).
class AppSpecRow {
  const AppSpecRow({required this.label, required this.value});

  final String label;
  final String value;

  factory AppSpecRow.fromJson(Map<String, dynamic> json) {
    return AppSpecRow(
      label: json['label'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'label': label, 'value': value};
}
