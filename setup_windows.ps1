# SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
# SPDX-License-Identifier: AGPL-3.0-only

# Elite Flutter Environment - Windows Setup Script
# This script sets up Flutter development environment on Windows using Scoop

Write-Host "🚀 Elite Flutter Environment - Windows Setup" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "⚠️  Warning: Running without administrator privileges" -ForegroundColor Yellow
    Write-Host "   Some operations may require elevation" -ForegroundColor Yellow
}

# Function to check if a command exists
function Test-CommandExists {
    param($command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try {
        if (Get-Command $command) { return $true }
    } catch {
        return $false
    } finally {
        $ErrorActionPreference = $oldPreference
    }
}

# Install Scoop if not present
if (-not (Test-CommandExists "scoop")) {
    Write-Host "📦 Installing Scoop package manager..." -ForegroundColor Green
    
    # Set execution policy
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    
    # Install Scoop
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    
    # Add Scoop to PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    
    Write-Host "✅ Scoop installed successfully" -ForegroundColor Green
} else {
    Write-Host "✅ Scoop already installed" -ForegroundColor Green
}

# Add buckets
Write-Host "📚 Adding Scoop buckets..." -ForegroundColor Green
scoop bucket add extras
scoop bucket add java
scoop bucket add versions

# Install required tools
Write-Host "🔧 Installing development tools..." -ForegroundColor Green

$tools = @(
    "git",
    "dart",
    "openjdk17",
    "just",
    "adb",
    "googlechrome"
)

foreach ($tool in $tools) {
    if (-not (scoop list | Select-String -Pattern "^$tool\s")) {
        Write-Host "  Installing $tool..." -ForegroundColor Yellow
        scoop install $tool
    } else {
        Write-Host "  $tool already installed" -ForegroundColor Gray
    }
}

# Install proto (Toolchain Version Manager)
Write-Host "📱 Installing proto (Toolchain Version Manager)..." -ForegroundColor Green
if (-not (Test-CommandExists "proto")) {
    # Install proto via Scoop
    scoop install proto
    Write-Host "✅ proto installed" -ForegroundColor Green
} else {
    Write-Host "✅ proto already installed" -ForegroundColor Green
}

# Install Flutter via proto
Write-Host "📱 Installing Flutter via proto..." -ForegroundColor Green
if (Test-CommandExists "proto") {
    proto install
    Write-Host "✅ Flutter installed via proto" -ForegroundColor Green
} else {
    Write-Host "❌ proto not found, cannot install Flutter" -ForegroundColor Red
}

# Set environment variables
Write-Host "⚙️  Setting environment variables..." -ForegroundColor Green

# JAVA_HOME
$javaHome = scoop prefix openjdk17
if (Test-Path $javaHome) {
    [Environment]::SetEnvironmentVariable("JAVA_HOME", $javaHome, [EnvironmentVariableTarget]::User)
    $env:JAVA_HOME = $javaHome
    Write-Host "  JAVA_HOME set to: $javaHome" -ForegroundColor Gray
}

# Android SDK (if needed)
$androidSdkPath = "$env:LOCALAPPDATA\Android\Sdk"
if (Test-Path $androidSdkPath) {
    [Environment]::SetEnvironmentVariable("ANDROID_HOME", $androidSdkPath, [EnvironmentVariableTarget]::User)
    [Environment]::SetEnvironmentVariable("ANDROID_SDK_ROOT", $androidSdkPath, [EnvironmentVariableTarget]::User)
    Write-Host "  ANDROID_HOME set to: $androidSdkPath" -ForegroundColor Gray
}

# CHROME_EXECUTABLE for Flutter Web
$chromePath = scoop prefix googlechrome
if (Test-Path "$chromePath\chrome.exe") {
    $chromeExe = "$chromePath\chrome.exe"
    [Environment]::SetEnvironmentVariable("CHROME_EXECUTABLE", $chromeExe, [EnvironmentVariableTarget]::User)
    $env:CHROME_EXECUTABLE = $chromeExe
    Write-Host "  CHROME_EXECUTABLE set to: $chromeExe" -ForegroundColor Gray
}

# Verify installations
Write-Host "`n✅ Setup Complete!" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan

Write-Host "`n📊 Verification:" -ForegroundColor White
if (Test-CommandExists "java") {
    Write-Host "  Java: $(java -version 2>&1 | Select-String -Pattern 'version' | Select-Object -First 1)" -ForegroundColor Gray
}
if (Test-CommandExists "dart") {
    Write-Host "  Dart: $(dart --version 2>&1 | Select-String -Pattern 'Dart' | Select-Object -First 1)" -ForegroundColor Gray
}
if (Test-CommandExists "just") {
    Write-Host "  Just: $(just --version)" -ForegroundColor Gray
}
if (Test-CommandExists "proto") {
    Write-Host "  Proto: $(proto --version)" -ForegroundColor Gray
}
if (Test-CommandExists "flutter") {
    Write-Host "  Flutter: $(flutter --version 2>&1 | Select-String -Pattern 'Flutter' | Select-Object -First 1)" -ForegroundColor Gray
}

Write-Host "`n🚀 Next steps:" -ForegroundColor White
Write-Host "   1. Restart your terminal/PowerShell for PATH changes to take effect" -ForegroundColor Gray
Write-Host "   2. Run 'just' to see available commands" -ForegroundColor Gray
Write-Host "   3. Run 'flutter doctor' to verify Flutter setup" -ForegroundColor Gray
Write-Host "   4. For Android development, install Android Studio and SDK" -ForegroundColor Gray

Write-Host "`n💡 Tip: For full Nix-like experience on Windows, consider using Nix for Windows or WSL2" -ForegroundColor Yellow
