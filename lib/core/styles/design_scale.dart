import 'package:flutter/widgets.dart';

/// Figma phone frame used across designs (same as Elite — 440-wide).
abstract final class DesignScale {
  static const double width = 440;
  static const double height = 956;

  static double of(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    return (screenW / width).clamp(0.82, 1.0);
  }

  static double w(BuildContext context, double figmaPx) =>
      figmaPx * of(context);

  static double h(BuildContext context, double figmaPx) =>
      w(context, figmaPx);
}
