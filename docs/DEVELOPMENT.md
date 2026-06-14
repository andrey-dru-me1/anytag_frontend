<!--
SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
SPDX-License-Identifier: AGPL-3.0-only
-->

# Development Guide for anytag_frontend

## Quick Start

### 1. Install Prerequisites

#### proto (Toolchain Version Manager)

This project uses [`proto`](https://moonrepo.dev/proto) to manage tool versions (pinned in [`.prototools`](../.prototools)). Proto manages **all** CLI tools including Flutter, Dart, and `just`.

Install prerequisites:

```bash
# macOS
brew install git unzip gzip xz

# Ubuntu / Debian
apt-get install git unzip gzip xz-utils

# RHEL-based / Fedora
dnf install git unzip gzip xz
```

Then install the proto itself:

```bash
# Bash shell
bash <(curl -fsSL https://moonrepo.dev/install/proto.sh)

# Fish shell
bash (curl -fsSL https://moonrepo.dev/install/proto.sh | psub)
```

> These are the official instructions above (see [https://moonrepo.dev/docs/proto/install](https://moonrepo.dev/docs/proto/install) for more). You can install proto using your favorite package manager instead. Then you won't be able to upgrade proto using `proto upgrade` but its version will be tracked by package manager. You may need to set up some things manually for your configuration.
>
> ```bash
> # It works well for macOS, fish and brew
> brew install proto
> ```

After installing, register proto in your shell:

```bash
# For bash/zsh/fish — proto automatically detects and sets up
proto setup
# Restart your shell or source the config file
```

#### Android SDK & Command-Line Tools

Required for building and testing Android apps. The recommended approach is to install via **Android Studio**.

1. Download and install [Android Studio](https://developer.android.com/studio)
2. Open Android Studio and go to:
   **Settings > Languages & Frameworks > Android SDK > SDK Tools**
3. Check and install:
   - **Android SDK Command-line Tools (latest)**
   - **Android SDK Platform-Tools**
4. Apply the changes

> **Recommended for macOS.** Many alternative installation methods (Homebrew, manual SDK Manager) have proven unreliable — this is the only approach that consistently works.

For the official guide, see: [Android Studio Install Guide](https://developer.android.com/studio/install)

### 2. Clone and Setup

```bash
cd anytag_frontend

# Install proto-managed tools (flutter, dart, just, etc.)
proto install
```

### 3. Verify Installation

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

## Development Workflow

### 1. Run the App

```bash
flutter run
```

### 2. Run Tests

```bash
flutter test
```

### 3. Common Development Tasks

```bash
# Format code
dart format .

# Lint code
flutter analyze

# Build for Android
flutter build apk --release
flutter build appbundle --release

# Build for iOS (macOS only)
flutter build ios --release

# Build for web
flutter build web --release

# Update dependencies
flutter pub upgrade

# Deep clean (Flutter + Gradle)
# Run: flutter clean
```

## Project Structure

The project follows a standard Flutter application structure:

```txt
anytag_frontend/
  lib/                   # Application source code
    main.dart            # Application entry point
  test/                  # Tests
    widget_test.dart     # MyApp smoke test
    fakes/
      post_service_fake.dart  # Fake IPostService for widget tests
    models/
      post_test.dart     # Post model unit tests (8 tests)
    services/
      post_service_test.dart  # PostService unit tests via mock adapter (6 tests)
    screens/
      posts_screen_test.dart  # PostsScreen widget tests via FakePostService (4 tests)
  android/               # Android platform files (Kotlin, Gradle)
  ios/                   # iOS platform files (Xcode, Swift)
  web/                   # Web platform files
  linux/                 # Linux platform files (CMake, C++)
  macos/                 # macOS platform files (Xcode, Swift)
  windows/               # Windows platform files (CMake, C++)
  docs/                  # Documentation
  Justfile               # Command runner
  .prototools            # Tool version pinning
```

As the application grows, the `lib/` directory will be organized into:

- **`lib/screens/`** — Application screens and pages
- **`lib/widgets/`** — Reusable UI components
- **`lib/services/`** — API clients and business logic
- **`lib/models/`** — Data models and DTOs
- **`lib/providers/`** — State management
- **`lib/utils/`** — Utilities and helpers

## Flutter Version Management

The Flutter version is pinned in [`.prototools`](../.prototools):

> **⚠️ WARNING:** Never run `flutter upgrade`. This project uses [`proto`](https://moonrepo.dev/proto) to manage the Flutter SDK version (pinned in [`.prototools`](../.prototools)). Running `flutter upgrade` directly bypasses proto, installs an arbitrary version, and breaks project consistency and determinism. Even if Flutter itself suggests `flutter upgrade` (e.g. when a newer version is available), ignore that suggestion. To update Flutter, use `proto pin flutter <version>` followed by `proto install flutter` — see below.

```toml
[plugins]
flutter = "3.44.2"
```

**Frequent proto commands for Flutter:**

```bash
# Install the Flutter version specified in .prototools
proto install flutter

# Pin a specific Flutter version
proto pin flutter 3.44.0

# List available remote releases
proto versions flutter

# Run Flutter commands via the proto-managed SDK
flutter doctor
flutter --version
dart format .
```

To change the Flutter version:

```bash
# Update .prototools
proto pin flutter 3.22.0

# Install the new version
proto install flutter
```

## CI/CD

The project includes GitHub Actions workflows that run on every push and pull request to `master` and `develop`:

- [`.github/workflows/ci.yml`](.github/workflows/ci.yml) — Builds, tests, lints, and checks formatting

## Platform-Specific Notes

### macOS / Linux

Both platforms are supported via proto.

### Windows

See [WINDOWS.md](./WINDOWS.md) for detailed Windows setup via PowerShell and Scoop.

## Contributing

1. Ensure all tests pass: `flutter test`
2. Format code: `dart format .`
3. Check linting: `flutter analyze`
4. Update documentation if needed
5. Create pull request

## See Also

- [Troubleshooting](./TROUBLESHOOTING.md) — Common issues and solutions
- [Dependency Management](./DEPENDENCIES.md) — Adding and updating Flutter dependencies
- [IDE Setup](./IDE_SETUP.md) — VS Code, Android Studio, and IntelliJ configuration
- [REUSE Compliance](./REUSE.md) — License management and SPDX headers
- [Git Workflow](./GIT_WORKFLOW.md) — Branch strategy, commit conventions, and PR guidelines
- [Windows Setup](./WINDOWS.md) — Windows-specific development setup
- [Android SDK Setup](./IDE_SETUP.md#android-sdk--command-line-tools) — Installing Android SDK and command-line tools
