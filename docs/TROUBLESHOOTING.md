<!--
SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
SPDX-License-Identifier: AGPL-3.0-only
-->

# Troubleshooting

## Flutter SDK Issues

```bash
# Check current Flutter version
flutter --version

# Reinstall Flutter SDK via proto
proto uninstall flutter
proto install flutter
```

## Build Issues

```bash
# Deep clean everything
flutter clean

# Clean only Flutter build cache
flutter clean

# Re-run pub get
flutter pub get

# iOS-specific: clean Pods
cd ios && pod deintegrate && pod install
```

## IDE Issues

```bash
# Regenerate VS Code configuration
# Delete .vscode/settings.json and reopen the project
# The Flutter extension will prompt to configure SDK path

# Clear Dart/Flutter analysis cache
rm -rf .dart_tool/
flutter pub get
```

## Platform-Specific Issues

### Android

```bash
# Check Android toolchain
flutter doctor -v

# Verify JAVA_HOME
echo $JAVA_HOME

# Clean Gradle cache
rm -rf ~/.gradle/caches/
rm -rf android/.gradle/
```

#### Android Licenses Not Accepted

If `flutter doctor --android-licenses` accepts all licenses but `flutter doctor` still shows them as not accepted — and subsequent runs keep presenting the same licenses to accept again as if they were never accepted — run it with `sudo`:

```bash
sudo flutter doctor --android-licenses
```

This is a known issue where license acceptance doesn't persist for the user account due to permission problems with the license file. Running with `sudo` resolves it reliably.

### iOS / macOS

```bash
# Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/

# Reinstall Pods
cd ios && pod install --repo-update

# Check CocoaPods version
pod --version
```

### Web

```bash
# Verify Chrome is available
google-chrome --version
```

### Windows

See [WINDOWS.md](./WINDOWS.md) for Windows-specific troubleshooting.

## See Also

- [Development Guide](./DEVELOPMENT.md) — Development workflow, common tasks, and CI/CD
- [Dependency Management](./DEPENDENCIES.md) — Adding and updating dependencies
- [REUSE Compliance](./REUSE.md) — License management and SPDX headers
