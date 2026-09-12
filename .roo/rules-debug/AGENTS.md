<!--
SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
SPDX-License-Identifier: AGPL-3.0-only
-->

# Debug Mode - Project Debug Rules (Non-Obvious Only)

## Known Gotchas

- **IntrinsicShield 3-frame delay**: [`IntrinsicShield`](lib/widgets/intrinsic_shield.dart) + [`SafeTableScrollWrapper`](lib/widgets/safe_table_scroll_wrapper.dart) cause a 3-frame layout delay (~50ms) when rendering inline LaTeX inside tables with `IntrinsicColumnWidth`. Content is invisible during first 2 frames. This is by design — see the doc comment in `safe_table_scroll_wrapper.dart` lines 8-21.
- **flutter_math_fork + RenderTable crash**: Using inline LaTeX (via `flutter_math_fork`) inside a `RenderTable` with `IntrinsicColumnWidth` will crash without `IntrinsicShield`. The error is a debug assertion during intrinsic measurement — not a runtime error during normal layout.
- **API endpoint**: Backend runs on port 3000 (`10.0.2.2:3000` for Android emulator, `127.0.0.1:3000` otherwise). No HTTPS configured — HTTP only.
- **No real tests**: [`test/widget_test.dart`](test/widget_test.dart) is the default Flutter counter smoke test — it does NOT test the actual app (Posts screen). Test failures may be misleading.

## Environment

- Flutter 3.44.0 managed by `proto` (not `fvm`). Run `proto install flutter` if SDK is missing.
- Format check can fail CI even if `flutter analyze` passes — always run `dart format --set-exit-if-changed .`.
