import 'package:flutter/material.dart';

/// Wraps [child] so tapping anywhere outside a field dismisses the keyboard.
class FocusHandler extends StatelessWidget {
  const FocusHandler({super.key, required this.child});

  final Widget child;

  static void tap(BuildContext context, [VoidCallback? call]) {
    final currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
    call?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => tap(context),
      child: child,
    );
  }
}
