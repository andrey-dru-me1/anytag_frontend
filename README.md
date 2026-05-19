<!--
SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
SPDX-License-Identifier: AGPL-3.0-only
-->

# anytag_frontend

![logo](assets/main_logo.svg)

Flutter frontend for the Anytag social tagging application.

## Features

- Cross-platform: Android, iOS, Web, Linux, macOS, Windows
- Proto-managed Flutter SDK pinned via `.prototools`
- Just command runner for standardized workflows
- PowerShell setup script for Windows
- REUSE-compliant licensing

## Quick Start

### macOS / Linux

```bash
# Clone and enter the project
cd anytag_frontend

# Install all tools pinned in .prototools (includes Flutter)
proto install

# Run the application
flutter run
```

### Windows

```powershell
.\setup_windows.ps1
flutter run
```

## Common Commands

| Command                       | Description                       |
| ----------------------------- | --------------------------------- |
| `flutter run`                 | Run application on default device |
| `flutter test`                | Run tests                         |
| `flutter analyze`             | Code analysis                     |
| `dart format .`               | Code formatting                   |
| `flutter build apk --release` | Build Android release APK         |
| `flutter build ios --release` | Build for iOS (macOS only)        |
| `flutter build web --release` | Build for web                     |
| `flutter clean`               | Clean build cache                 |
| `flutter pub upgrade`         | Update dependencies               |

## Documentation

- [Development Guide](docs/DEVELOPMENT.md) — Setup and workflow
- [Dependency Management](docs/DEPENDENCIES.md) — Adding and updating dependencies
- [IDE Setup](docs/IDE_SETUP.md) — VS Code, Zed, Android Studio configuration
- [Troubleshooting](docs/TROUBLESHOOTING.md) — Common issues
- [Windows Setup](docs/WINDOWS.md) — Windows development environment
- [Git Workflow](docs/GIT_WORKFLOW.md) — Branch strategy, commits, PRs
- [REUSE Compliance](docs/REUSE.md) — License management and SPDX headers

## Architecture

```txt
lib/
  main.dart            # Application entry point
test/
  widget_test.dart     # Basic widget test
docs/                  # Project documentation
Justfile               # Command runner
.prototools            # Tool version pinning
```

## License

AGPL-3.0-only. See [LICENSE](LICENSE) for details.
