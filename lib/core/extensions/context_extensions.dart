import 'package:flutter/material.dart';

import '../styles/design_scale.dart';

extension ContextX on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  double get topSafe => MediaQuery.viewPaddingOf(this).top;
  double get bottomSafe => MediaQuery.viewPaddingOf(this).bottom;

  /// Scale factor vs Figma frame width `440`.
  double get designScale => DesignScale.of(this);

  /// Map a Figma px value to this device (see [DesignScale]).
  double dw(double figmaPx) => DesignScale.w(this, figmaPx);

  /// Bottom padding equal to the on-screen keyboard height.
  EdgeInsets get keyboardInset =>
      EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(this).bottom);

  void dismissKeyboard() {
    final focus = FocusScope.of(this);
    if (focus.hasFocus) focus.unfocus();
  }
}
