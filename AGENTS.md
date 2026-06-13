<!--
SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
SPDX-License-Identifier: AGPL-3.0-only
-->

# AGENTS.md

This file provides guidance to agents when working with code in this repository.

## Toolchain & Setup

- **Toolchain manager**: `proto` (pinned in [`.prototools`](.prototools)) manages Flutter 3.44.0, Dart, `just`, `uv`. NOT `fvm` or direct SDK.
- **Command runner**: Use `just <command>` (see [Justfile](Justfile)). e.g. `just test`, `just analyze`, `just format`.
- **Format checking**: CI enforces `dart format --set-exit-if-changed .` (fails if any file is unformatted, not just analysis warnings).

## Mandatory Conventions (not enforced by linter)

- **SPDX headers**: Every source file MUST start with SPDX-FileCopyrightText and SPDX-License-Identifier comments. REUSE compliance is CI-checked via [`.github/workflows/reuse.yml`](.github/workflows/reuse.yml).
- **YouTrack ticket**: EVERY branch and commit MUST reference a YouTrack ticket ID (e.g. `ANY-1234`). Commit format: `type(TICKET-ID): subject`. See [`docs/GIT_WORKFLOW.md`](docs/GIT_WORKFLOW.md).
- **Merge strategy**: Merge commits (not squash, not rebase). See [`docs/GIT_WORKFLOW.md`](docs/GIT_WORKFLOW.md).
- **Branch prefixes**: `feature/*`, `bugfix/*`, `hotfix/*` (from master), `chore/*`, `release/*`.

## Architecture Notes

- **API base URL**: [`PostService`](lib/services/post_service.dart:20-25) uses `10.0.2.2:3000` for Android emulator, `127.0.0.1:3000` otherwise. Port 3000, no HTTPS configured yet.
- **Custom render object**: [`IntrinsicShield`](lib/widgets/intrinsic_shield.dart) is a `RenderProxyBox` workaround for a `flutter_math_fork` + `RenderTable` intrinsic measurement crash. Required when using inline LaTeX inside tables with `IntrinsicColumnWidth`.
- **Local fork**: [`packages/flutter_math_fork/`](packages/flutter_math_fork/) is a local vendored copy (not from pub.dev).
- **Routing**: Simple `MaterialApp` + direct widget routing. No go_router or Navigator 2.0.
- **Only 1 test exists**: [`test/widget_test.dart`](test/widget_test.dart) is the default Flutter counter smoke test — it does NOT match the actual app (Posts screen). Real tests need to be written from scratch.

## Dependencies

| Package             | Purpose                                   |
| ------------------- | ----------------------------------------- |
| `dio`               | HTTP client                               |
| `markdown_widget`   | Markdown rendering                        |
| `flutter_math_fork` | LaTeX rendering (vendored in `packages/`) |
| `markdown`          | Markdown parser (used by latex widget)    |
