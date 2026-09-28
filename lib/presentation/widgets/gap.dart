import 'package:flutter/widgets.dart';

/// Lightweight spacing widget. Use with [AppSpacing] tokens, e.g.
/// `const Gap(AppSpacing.t16)` for a vertical gap or
/// `const Gap.h(AppSpacing.t08)` for a horizontal one.
class Gap extends StatelessWidget {
  const Gap(this.size, {super.key}) : _axis = Axis.vertical;
  const Gap.h(this.size, {super.key}) : _axis = Axis.horizontal;

  final double size;
  final Axis _axis;

  @override
  Widget build(BuildContext context) {
    return _axis == Axis.vertical
        ? SizedBox(height: size)
        : SizedBox(width: size);
  }
}
