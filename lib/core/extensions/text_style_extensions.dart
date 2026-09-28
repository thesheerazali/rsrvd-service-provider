import 'package:flutter/material.dart';

extension TextStyleX on TextStyle {
  TextStyle fs(double size) => copyWith(fontSize: size);

  TextStyle cl(Color color) => copyWith(color: color);

  TextStyle removeHeight() => merge(const TextStyle(height: 0));

  /// FontWeight shorthand — `.w(5)` → Medium, `.w(7)` → Bold.
  TextStyle w(int weight) {
    final fontWeight = switch (weight) {
      1 => FontWeight.w100,
      2 => FontWeight.w200,
      3 => FontWeight.w300,
      4 => FontWeight.w400,
      5 => FontWeight.w500,
      6 => FontWeight.w600,
      7 => FontWeight.w700,
      8 => FontWeight.w800,
      9 => FontWeight.w900,
      _ => FontWeight.normal,
    };
    return copyWith(fontWeight: fontWeight);
  }
}
