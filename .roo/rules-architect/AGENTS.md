<!--
SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
SPDX-License-Identifier: AGPL-3.0-only
-->

# Architect Mode - Project Architecture Rules (Non-Obvious Only)

## Architectural Constraints

- **No state management yet**: The app uses raw `FutureBuilder` + `setState` in [`PostsScreen`](lib/screens/posts_screen.dart). Directories `lib/providers/` and `lib/utils/` are planned but don't exist. Any state management addition (Provider, Riverpod, BLoC) must be planned as a new addition.
- **Simple routing**: [`MaterialApp`](lib/main.dart:17-23) with direct widget routing. No go_router, Navigator 2.0, or named routes — all navigation is implicit through widget composition.
- **Single API pattern**: [`PostService`](lib/services/post_service.dart) uses `dio` with a hardcoded base URL. No interceptor pipeline, no auth headers, no error mapping layer yet.
- **Renderer coupling**: Inline LaTeX inside `IntrinsicColumnWidth` tables requires [`IntrinsicShield`](lib/widgets/intrinsic_shield.dart) — a custom `RenderProxyBox` — to prevent a crash in `flutter_math_fork`'s intrinsic measurement. This coupling exists because `flutter_math_fork` contains `LayoutBuilder` which asserts during intrinsic sizing. Any new widget containing `LayoutBuilder` placed inside `IntrinsicColumnWidth` tables will have the same problem.
- **Vendored dependency**: [`packages/flutter_math_fork/`](packages/flutter_math_fork/) is a local copy (not pub.dev). Modifications to it are possible but must be coordinated with the pubspec.yaml `dependency_overrides` or path reference.

## API Layer

- Base URL: `http://10.0.2.2:3000` (Android emulator) / `http://127.0.0.1:3000` (other platforms). Port 3000. No HTTPS.
- Backend response format: `{ "posts": [ { "id": int, "text": string }, ... ] }` (see [`Post.fromJson`](lib/models/post.dart:13-18)).
