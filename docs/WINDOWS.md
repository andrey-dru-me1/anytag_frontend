<!--
SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
SPDX-License-Identifier: AGPL-3.0-only
-->

# Windows Development Setup for anytag_frontend

## Overview

Windows development is supported via **PowerShell and Scoop** package manager. Unlike the backend (which requires WSL2 for Rust/Nix), the frontend can run natively on Windows thanks to Dart and Flutter's first-class Windows support.

The project includes an automated setup script: [`setup_windows.ps1`](../setup_windows.ps1).

## Quick Start

### Step 1: Run the Setup Script

```powershell
# Open PowerShell (can be run without administrator privileges)
.\setup_windows.ps1
```

This script will:

1. Install **Scoop** package manager (if not present)
2. Add Scoop buckets: `extras`, `java`, `versions`
3. Install required tools: `git`, `flutter`, `dart`, `openjdk17`, `just`, `adb`, `googlechrome`
4. Set environment variables: `JAVA_HOME`, `ANDROID_HOME`, `CHROME_EXECUTABLE`
5. Install the pinned Flutter version via proto
6. Add Flutter SDK `bin` to PATH

### Step 2: Restart Your Terminal

After the script completes:

```powershell
# Restart PowerShell for PATH changes
# Or refresh environment variables:
refreshenv
```

### Step 3: Verify Installation

```powershell
flutter doctor -v
just env-info
```

## Manual Setup (If the script fails)

### 1. Install Scoop

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

### 2. Install Required Tools

```powershell
scoop bucket add extras
scoop bucket add java
scoop bucket add versions
scoop install git dart openjdk17 just adb googlechrome
```

### 3. Install Flutter via Scoop

```powershell
scoop install flutter
```

### 4. Install proto (Toolchain Version Manager)

```powershell
# Install proto
scoop install proto
```

### 5. Install the Pinned Flutter Version

```powershell
# Install all tools pinned in .prototools
proto install
```

### 6. Set Environment Variables

```powershell
# JAVA_HOME
$javaHome = scoop prefix openjdk17
[Environment]::SetEnvironmentVariable("JAVA_HOME", $javaHome, "User")

# CHROME_EXECUTABLE
$chromePath = scoop prefix googlechrome
[Environment]::SetEnvironmentVariable("CHROME_EXECUTABLE", "$chromePath\chrome.exe", "User")

# Android SDK (if installed)
$androidSdkPath = "$env:LOCALAPPDATA\Android\Sdk"
if (Test-Path $androidSdkPath) {
    [Environment]::SetEnvironmentVariable("ANDROID_HOME", $androidSdkPath, "User")
    [Environment]::SetEnvironmentVariable("ANDROID_SDK_ROOT", $androidSdkPath, "User")
}
```

## Common Issues and Solutions

### Issue: Scoop installation fails

```powershell
# Try with administrator rights
Start-Process PowerShell -Verb RunAs -ArgumentList "-File .\setup_windows.ps1"
```

### Issue: Flutter not found after installation

```powershell
# Check if Flutter is in PATH
flutter --version

# Reinstall via proto
proto install flutter
```

### Issue: Java not found

```powershell
# Check Java installation
scoop list openjdk17
# Reinstall if needed
scoop uninstall openjdk17
scoop install openjdk17
```

### Issue: Flutter Web not working

```powershell
# Verify Chrome is installed
scoop list googlechrome
# Check CHROME_EXECUTABLE environment variable
echo $env:CHROME_EXECUTABLE
```

### Issue: Slow performance

- Store the project on an SSD
- Use Windows Defender exclusions for project directories
- Increase Swap file size if running low on memory

## Android Development on Windows

1. Install **Android Studio** from <https://developer.android.com/studio>
2. Install Android SDK Command-line Tools via SDK Manager
3. Accept Android licenses:

    ```powershell
    flutter doctor --android-licenses
    ```

4. Ensure `ANDROID_HOME` points to your Android SDK installation

## VS Code on Windows

1. Install VS Code
2. Install **Flutter** and **Dart** extensions
3. Open the project folder
4. VS Code will detect the proto-managed Flutter SDK from `.vscode/settings.json`

## Verification Checklist

After setup, verify everything works:

```powershell
# 1. Check Flutter
flutter --version

# 2. Check Dart
dart --version

# 3. Check Java
java -version

# 4. Check Flutter doctor
flutter doctor -v

# 5. Run tests
just test
```

## See Also

- [Development Guide](./DEVELOPMENT.md) — General development workflow
- [IDE Setup](./IDE_SETUP.md) — IDE configuration
- [Troubleshooting](./TROUBLESHOOTING.md) — Common issues
