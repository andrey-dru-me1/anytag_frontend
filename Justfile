# SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
# SPDX-License-Identifier: AGPL-3.0-only

# Elite Flutter Environment - Command Automation
# Run with: just <command>

# Default command: show available commands
default:
  just --list

# Run the application on default device
run:
  @echo "🚀 Running Flutter application..."
  flutter run

# Build release APK for Android
build-apk:
  @echo "📱 Building Android release APK..."
  flutter build apk --release
  @echo "✅ APK built at: build/app/outputs/flutter-apk/app-release.apk"
  @echo "   Size: $(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)"

# Build app bundle for Play Store
build-appbundle:
  @echo "📦 Building Android App Bundle..."
  flutter build appbundle --release
  @echo "✅ App Bundle built at: build/app/outputs/bundle/release/app-release.aab"

# Build for iOS (macOS only)
build-ios:
  @echo "🍎 Building iOS..."
  flutter build ios --release
  @echo "✅ iOS build complete"

# Build for web
build-web:
  @echo "🌐 Building for web..."
  flutter build web --release
  @echo "✅ Web build at: build/web/"

# Deep clean: Flutter clean + Gradle cache
clean-all:
  #!/usr/bin/env bash
  set -euo pipefail
  echo "🧹 Deep cleaning environment..."
  
  # Flutter clean
  echo "  • Running flutter clean..."
  flutter clean
  
  # Clean Gradle cache
  echo "  • Cleaning Gradle cache..."
  rm -rf ~/.gradle/caches/ || true
  rm -rf android/.gradle/ || true
  
  # Remove build directories
  echo "  • Removing build directories..."
  rm -rf build/ ios/Pods/ ios/.symlinks/ || true
  
  echo "✅ Deep clean complete!"

# Run tests
test:
  @echo "🧪 Running tests..."
  flutter test

# Run tests with coverage
test-coverage:
  @echo "📊 Running tests with coverage..."
  flutter test --coverage
  @echo "Coverage report generated at: coverage/lcov.info"

# Format code
format:
  @echo "🎨 Formatting code..."
  dart format .

# Analyze code
analyze:
  @echo "🔍 Analyzing code..."
  flutter analyze

# Doctor check
doctor:
  @echo "👨‍⚕️ Running Flutter doctor..."
  flutter doctor -v

# Update dependencies
deps-update:
  #!/usr/bin/env bash
  set -euo pipefail
  echo "📦 Updating dependencies..."
  flutter pub upgrade
  if [ -d "ios" ]; then
    cd ios && pod install --repo-update && cd ..
  fi

# Generate localization files (if using intl)
l10n-generate:
  @echo "🌍 Generating localization files..."
  flutter gen-l10n

# Show environment info
env-info:
  @echo "📊 Environment Information:"
  @echo "  • System: $(uname -s) $(uname -m)"
  @echo "  • Flutter: $(flutter --version 2>/dev/null | head -1 || echo 'Not found')"
  @echo "  • Dart: $(dart --version 2>/dev/null | head -1 || echo 'Not found')"
  @echo "  • Java: $(java -version 2>&1 | head -1 || echo 'Not found')"
