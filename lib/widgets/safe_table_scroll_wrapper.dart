import 'package:flutter/material.dart';

/// Wraps a [Table] widget with a horizontal [Scrollbar] and hides it until
/// the second layout pass completes (when [RenderIntrinsicShield] has cached
/// actual child sizes), avoiding a visible blink between the estimated-size
/// layout and the correct-size layout.
///
/// ## Two-pass layout
///
/// 1. **Frame 1** — the table is laid out with estimated column widths
///    (invisible to the user). [RenderIntrinsicShield] caches the actual
///    child sizes and schedules a post-frame callback that calls
///    `markNeedsLayout()`.
/// 2. **Post-frame callback 1** — schedules callback 2.
/// 3. **Post-frame callback 2 (IntrinsicShield)** — `markNeedsLayout()`
///    propagates up to the relayout boundary, scheduling Frame 2.
/// 4. **Frame 2** — the table is laid out with cached sizes, producing
///    correct column widths (still invisible).
/// 5. **Post-frame callback 2 (this)** — sets `_ready = true`.
/// 6. **Frame 3** — the table becomes visible with correct column widths.
///
/// The total delay is ~50 ms (3 frames at 60 fps), which is imperceptible.
class SafeTableScrollWrapper extends StatefulWidget {
  final Widget child;

  const SafeTableScrollWrapper({super.key, required this.child});

  @override
  State<SafeTableScrollWrapper> createState() => _SafeTableScrollWrapperState();
}

class _SafeTableScrollWrapperState extends State<SafeTableScrollWrapper> {
  late final ScrollController _scrollController;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Chain two post-frame callbacks to wait for the second layout pass.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _ready = true);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      // Hide the table on the first two frames to avoid a visible blink
      // between the estimated-size layout and the correct-size layout.
      opacity: _ready ? 1.0 : 0.0,
      alwaysIncludeSemantics: false,
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        trackVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
