import 'package:flutter/widgets.dart';

extension WidgetSizeX on GlobalKey {
  double? get widgetHeight {
    final renderBox = currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size.height;
  }

  double? get widgetWidth {
    final renderBox = currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size.width;
  }
}
