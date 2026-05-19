<!--
SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
SPDX-License-Identifier: AGPL-3.0-only
-->

# Dependency Management

## Adding Flutter/Dart Dependencies

Use `flutter pub add` to add new dependencies:

```bash
# Add a production dependency
flutter pub add <package_name>

# Add a development dependency
flutter pub add --dev <package_name>
```

This automatically updates both `pubspec.yaml` and `pubspec.lock`. Alternatively, you can manually edit `pubspec.yaml` and then run `flutter pub get` to update the lockfile.

## Updating Flutter/Dart Dependencies

```bash
# Update all dependencies within their version constraints
flutter pub upgrade

# Update a specific package to the latest compatible version
flutter pub upgrade <package_name>

# Check for newer versions (without updating)
flutter pub outdated

# Major version updates
flutter pub upgrade --major-versions
```

## Flutter SDK

The Flutter SDK version is managed via proto and pinned in `.prototools`:

```toml
[plugins]
flutter = "3.44.0"
```

To update the Flutter SDK version:

```bash
# Pin a new version
proto pin flutter 3.22.0

# Install the new version
proto install flutter

# Update iOS Pods if needed
cd ios && pod install --repo-update
```

## See Also

- [Development Guide](./DEVELOPMENT.md) — Development workflow and common tasks
- [Troubleshooting](./TROUBLESHOOTING.md) — Common issues and solutions
