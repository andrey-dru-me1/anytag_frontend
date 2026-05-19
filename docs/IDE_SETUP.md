<!--
SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
SPDX-License-Identifier: AGPL-3.0-only
-->

# IDE Setup for anytag_frontend

## VS Code

Recommended extensions for Flutter development:

- **Flutter** (Dart Code) — Flutter and Dart language support, debugging, hot reload
- **YAML** — YAML file support
- **vscode-just** — Just command runner support

## Zed

Zed has built-in Dart/Flutter support. Open the project and it will detect the proto-managed SDK automatically.

## IntelliJ IDEA / Android Studio

1. Install "Flutter" and "Dart" plugins
2. Open the project directory
3. Configure Flutter SDK path to point to the proto-managed SDK location (e.g., `~/.proto/tools/flutter/3.41.4/`)

### Recommended IntelliJ Plugins

- **Flutter** — Flutter framework support
- **Dart** — Dart language support
- **Just** — Just command runner support (community plugin)

## Android SDK & Command-Line Tools

Required for building and testing Android apps. The recommended approach for macOS is to install via **Android Studio**.

1. Download and install [Android Studio](https://developer.android.com/studio)
2. Open Android Studio and go to:
   **Settings > Languages & Frameworks > Android SDK > SDK Tools**
3. Check and install:
   - **Android SDK Command-line Tools (latest)**
   - **Android SDK Platform-Tools**
4. Click **Apply** and wait for the download to complete

> **Recommended for macOS.** Many alternative installation methods (Homebrew, manual SDK Manager) have proven unreliable — this is the only approach that consistently works.

Verify the setup:

```bash
# Check Android SDK status
flutter doctor

# Accept Android licenses (required for building)
flutter doctor --android-licenses
```

> **Troubleshooting** If after that `flutter doctor` shows that android licenses still aren't accepted run it as superuser:
>
> ```bash
> sudo flutter doctor --android licenses
> ```
>
> This is the only solution that worked on macOS.

For the official guide, see: [Android Studio Install Guide](https://developer.android.com/studio/install)

## See Also

- [Development Guide](./DEVELOPMENT.md) — Development workflow and common tasks
- [Troubleshooting](./TROUBLESHOOTING.md) — Common issues and solutions
