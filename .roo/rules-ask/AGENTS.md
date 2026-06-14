<!--
SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
SPDX-License-Identifier: AGPL-3.0-only
-->

# Ask Mode - Project Documentation Context (Non-Obvious Only)

## Counterintuitive Facts

- The only test ([`test/widget_test.dart`](test/widget_test.dart)) is the default Flutter counter smoke test — it does **not** match the actual app which shows a Posts screen.
- [`docs/DEVELOPMENT.md`](docs/DEVELOPMENT.md) lists `lib/providers/` and `lib/utils/` directories in the project structure, but these directories do **not exist yet** — the project is in early development.
- The [`packages/flutter_math_fork/`](packages/flutter_math_fork/) directory is a local vendored fork, not a real pub.dev package. Its `pubspec.yaml` differs from the published version.

## Key Documentation Files

- [`docs/GIT_WORKFLOW.md`](docs/GIT_WORKFLOW.md) — Mandatory YouTrack ticket ID conventions for branches and commits.
- [`docs/REUSE.md`](docs/REUSE.md) — SPDX license header requirements.
- [`Justfile`](Justfile) — All build/lint/test commands via `just <command>`.

## API Architecture

- Single service class [`PostService`](lib/services/post_service.dart) with a `fetchPosts()` method hitting `GET /posts`.
- No authentication, no state management — just a `FutureBuilder` in the UI.
