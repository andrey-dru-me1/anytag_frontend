import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Global cache mapping formula identity to its measured size.
///
/// This cache survives widget rebuilds because it's stored at the static
/// level, not on the render object. When [RenderIntrinsicShield] render
/// objects are recreated (e.g., during table rebuild), they can still
/// retrieve the cached size from this map.
final Map<_IntrinsicSizeKey, Size> _cache = {};

/// Key for the global intrinsic size cache.
///
/// Uses formula text content and font size as the identity. This is stable
/// across widget rebuilds because the formula text doesn't change.
class _IntrinsicSizeKey {
  const _IntrinsicSizeKey(this.formula, this.fontSize);
  final String formula;
  final double fontSize;

  @override
  bool operator ==(Object other) =>
      other is _IntrinsicSizeKey &&
      other.formula == formula &&
      other.fontSize == fontSize;

  @override
  int get hashCode => Object.hash(formula, fontSize);
}

/// Breaks the intrinsic measurement chain for inline math inside tables.
///
/// When a [WidgetSpan] containing a [Math.tex()] widget is placed inside a
/// [RenderParagraph] that is itself inside a [RenderTable] using
/// [IntrinsicColumnWidth], the intrinsic size calculation cascades into
/// [flutter_math_fork]'s render tree which contains [LayoutBuilder] and
/// triggers a debug assertion during intrinsic measurement.
///
/// This widget breaks the intrinsic measurement chain by returning estimated
/// sizes based on [fontSize] instead of delegating to the child. After the
/// first layout pass, the child's actual size is cached in a global map and
/// a second layout pass is triggered so the table computes correct column
/// widths.
class IntrinsicShield extends SingleChildRenderObjectWidget {
  const IntrinsicShield({
    super.key,
    required this.fontSize,
    required this.formula,
    required super.child,
  });

  final double fontSize;
  final String formula;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderIntrinsicShield(fontSize: fontSize, formula: formula);

  @override
  void updateRenderObject(
          BuildContext context, RenderIntrinsicShield renderObject) =>
      renderObject
        ..formula = formula
        ..fontSize = fontSize;
}

/// The render object that shields intrinsic measurement.
///
/// Extends [RenderProxyBox] which provides default implementations for
/// [paint], [hitTestChildren], [applyPaintTransform], and the default
/// [performLayout] that lays out the child with parentUsesSize: true.
///
/// We override:
///   - [computeMinIntrinsicWidth] / [computeMaxIntrinsicWidth] /
///     [computeMinIntrinsicHeight] / [computeMaxIntrinsicHeight] to return
///     estimated or cached sizes instead of delegating to the child.
///   - [performLayout] to cache the child's actual size after layout and
///     schedule a second layout pass via post-frame callback.
class RenderIntrinsicShield extends RenderProxyBox {
  RenderIntrinsicShield({
    required double fontSize,
    required String formula,
  })  : _fontSize = fontSize,
        _formula = formula,
        _key = _IntrinsicSizeKey(formula, fontSize);

  double _fontSize;
  double get fontSize => _fontSize;
  set fontSize(double v) {
    if (_fontSize != v) {
      _fontSize = v;
      _key = _IntrinsicSizeKey(_formula, _fontSize);
      markNeedsLayout();
    }
  }

  String _formula;
  String get formula => _formula;
  set formula(String v) {
    if (_formula != v) {
      _formula = v;
      _key = _IntrinsicSizeKey(_formula, _fontSize);
      markNeedsLayout();
    }
  }

  _IntrinsicSizeKey _key;

  /// Returns the cached size from the global cache, or null.
  Size? get _cached => _cache[_key];

  /// Estimated width: cached size, or a rough estimate based on font size.
  double get _estWidth => _cached?.width ?? _fontSize * 12;

  /// Estimated height: cached size, or a rough estimate based on font size.
  double get _estHeight => _cached?.height ?? _fontSize * 1.4;

  @override
  double computeMinIntrinsicWidth(double height) => _estWidth;

  @override
  double computeMaxIntrinsicWidth(double height) => _estWidth;

  @override
  double computeMinIntrinsicHeight(double width) => _estHeight;

  @override
  double computeMaxIntrinsicHeight(double width) => _estHeight;

  @override
  void performLayout() {
    // Delegate layout to the child via RenderProxyBox's default implementation.
    super.performLayout();

    // Cache the child's actual size on the first layout pass.
    if (!_cache.containsKey(_key)) {
      _cache[_key] = child!.size;

      // Schedule a post-frame callback to trigger a second layout pass.
      // On the second pass, the cached size will be used for intrinsic
      // measurements, allowing the table to compute correct column widths.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (attached) markNeedsLayout();
      });
    }
  }
}
