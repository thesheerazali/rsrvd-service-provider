extension NullableStringX on String? {
  /// True when the string is non-null and not empty.
  bool get available => this != null && this!.trim().isNotEmpty;

  /// True when the string is null or empty (after trimming).
  bool get isBlank => !available;
}

extension StringX on String {
  /// Returns the segment after the last `": "`, useful for surfacing the
  /// readable part of an exception's `toString()`.
  String get splitError => split(': ').last;

  /// Initials of a full name, e.g. "John Doe" → "JD".
  String get initials =>
      trim().split(' ').where((e) => e.isNotEmpty).map((e) => e[0]).join();

  /// Capitalizes the first letter of [this] (rest unchanged).
  String get capitalizeFirst {
    final t = trimLeft();
    if (t.isEmpty) return this;
    final leading = substring(0, length - t.length);
    return '$leading${t[0].toUpperCase()}${t.length > 1 ? t.substring(1) : ''}';
  }

  /// Title-cases a person name: "john doe" → "John Doe".
  String get capitalizeWords {
    final t = trim();
    if (t.isEmpty) return t;
    return t
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .map((w) {
          if (w.length == 1) return w.toUpperCase();
          return '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}';
        })
        .join(' ');
  }
}
