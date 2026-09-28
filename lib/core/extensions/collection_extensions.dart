import 'dart:math';

extension NullableListX on List? {
  bool get available => this != null && this!.isNotEmpty;
}

extension NullableMapX on Map? {
  bool get available => this != null && this!.isNotEmpty;
}

extension IterableX<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension RandomElementX<T> on List<T> {
  T get randomValue => this[Random().nextInt(length)];
}

extension MapX on Map {
  Map<String, V> trimStringValues<K, V>() {
    return map<String, V>((key, value) {
      if (value is String) return MapEntry(key, value.trim() as V);
      return MapEntry(key, value);
    });
  }
}
