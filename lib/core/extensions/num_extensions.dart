import 'package:flutter/widgets.dart';

// NOTE: duration shorthands (2.seconds, 300.milliseconds, …) come from GetX's
// GetNumUtils — don't redefine them here or the extensions become ambiguous.
extension NumX on num {
  /// `12.radius()` → BorderRadius.circular(12)
  BorderRadius radius() => BorderRadius.circular(toDouble());

  /// Rounds only the top corners.
  BorderRadius top() => BorderRadius.vertical(top: Radius.circular(toDouble()));

  /// Rounds only the bottom corners.
  BorderRadius bottom() =>
      BorderRadius.vertical(bottom: Radius.circular(toDouble()));

  /// `16.h()` → SizedBox(height: 16)
  Widget h() => SizedBox(height: toDouble());

  /// `16.w()` → SizedBox(width: 16)
  Widget w() => SizedBox(width: toDouble());

  /// Square box of this size.
  Widget box() => SizedBox(height: toDouble(), width: toDouble());
}

extension IntX on int {
  /// Formats a byte count as a human-readable size (KB → MB → GB).
  String get readableSize {
    final kb = this / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(0)} KB';
    final mb = kb / 1024;
    if (mb < 1024) return '${mb.toStringAsFixed(1)} MB';
    return '${(mb / 1024).toStringAsFixed(1)} GB';
  }
}
