import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Composites [child] onto layers below using [blendMode].
///
/// Used for Figma layer blend modes (e.g. Color Dodge on the constellation).
class BlendMask extends SingleChildRenderObjectWidget {
  const BlendMask({
    super.key,
    required this.blendMode,
    super.child,
  });

  final BlendMode blendMode;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderBlendMask(blendMode);
  }

  @override
  void updateRenderObject(BuildContext context, RenderBlendMask renderObject) {
    renderObject.blendMode = blendMode;
  }
}

class RenderBlendMask extends RenderProxyBox {
  RenderBlendMask(BlendMode blendMode) : _blendMode = blendMode;

  BlendMode _blendMode;

  set blendMode(BlendMode value) {
    if (_blendMode == value) return;
    _blendMode = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.saveLayer(
      offset & size,
      Paint()..blendMode = _blendMode,
    );
    if (child != null) {
      context.paintChild(child!, offset);
    }
    context.canvas.restore();
  }
}
