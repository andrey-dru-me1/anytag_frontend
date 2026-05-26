import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A widget that shields intrinsic size measurement from propagating to its
/// child.
///
/// When a [WidgetSpan] containing a [Math.tex()] widget is placed inside a
/// [RenderParagraph] that is itself inside a [RenderTable] using
/// [IntrinsicColumnWidth], the intrinsic size calculation cascades into
/// [flutter_math_fork]'s render tree ([RenderLine] → [RenderCustomLayout] →
/// [RenderRelativeWidthColumn]). The [RenderRelativeWidthColumn._getIntrinsicSize]
/// calls [RenderBox.getMaxIntrinsicHeight] on children that contain a
/// [LayoutBuilder] (via [Consumer<FlutterMathMode>]), which triggers a debug
/// assertion in Flutter's [RenderLayoutBuilder._debugThrowIfNotCheckingIntrinsics].
///
/// This widget breaks the intrinsic measurement chain by providing intrinsic
/// sizes based on the estimated font metrics rather than delegating to the child.
class IntrinsicShield extends SingleChildRenderObjectWidget {
  const IntrinsicShield({
    super.key,
    required this.fontSize,
    required super.child,
  });

  final double fontSize;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderIntrinsicShield(fontSize: fontSize);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderIntrinsicShield renderObject) {
    renderObject.fontSize = fontSize;
  }
}

class RenderIntrinsicShield extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  RenderIntrinsicShield({required double fontSize}) : _fontSize = fontSize;

  double get fontSize => _fontSize;
  double _fontSize;
  set fontSize(double value) {
    if (_fontSize != value) {
      _fontSize = value;
      markNeedsLayout();
    }
  }

  double get _estimatedHeight => _fontSize * 1.4;
  double get _estimatedCharWidth => _fontSize * 0.6;

  @override
  double computeMinIntrinsicWidth(double height) {
    return _estimatedCharWidth;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _estimatedCharWidth * 20;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _estimatedHeight;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _estimatedHeight;
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(!debugNeedsLayout);
    return _fontSize * 0.8;
  }

  @override
  void performLayout() {
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
    } else {
      size = constraints.constrain(Size(_estimatedCharWidth, _estimatedHeight));
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (child != null) {
      return constraints.constrain(child!.getDryLayout(constraints));
    }
    return constraints.constrain(Size(_estimatedCharWidth, _estimatedHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      final childParentData = child!.parentData as BoxParentData;
      context.paintChild(child!, childParentData.offset + offset);
    }
  }
}
