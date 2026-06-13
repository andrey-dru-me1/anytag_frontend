<!--
SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
SPDX-License-Identifier: AGPL-3.0-only
-->

# Code Mode - Project Coding Rules (Non-Obvious Only)

## Must-Do Before Committing

- Add [`SPDX-FileCopyrightText` and `SPDX-License-Identifier`](AGENTS.md:13-14) headers to EVERY new source file (not enforced by linter/flutter analyze).
- CI format check uses `dart format --set-exit-if-changed .` — run `just format` before pushing.

## Import Ordering Convention

1. Flutter/Dart SDK imports (e.g. `package:flutter/…`)
2. Third-party package imports (e.g. `package:dio/…`, `package:markdown/…`)
3. Internal relative imports (e.g. `../models/post.dart` or `package:anytag_frontend/…`)

See [`lib/services/post_service.dart`](lib/services/post_service.dart:4-6) for an example.

## Dependencies

- `flutter_math_fork` is a **local vendored copy** at [`packages/flutter_math_fork/`](packages/flutter_math_fork/) — NOT from pub.dev. Do NOT add it via `flutter pub add`.
- Dependencies are declared in [`pubspec.yaml`](pubspec.yaml) — use `flutter pub add <package>` to add new ones.

## Commits

- Every commit MUST reference a YouTrack ticket: `type(TICKET-ID): subject`. See [`docs/GIT_WORKFLOW.md`](docs/GIT_WORKFLOW.md).
- Branch naming: `feature/ANY-1234-description`, `bugfix/ANY-5678-description`, etc.
