#!/usr/bin/env bash
# Rebuild the launcher after editing launcher/app/src/main/res/values/config.xml and reinstall it on the TV.
# Needs: adb (brew install --cask android-platform-tools), OpenJDK 21 (brew install openjdk@21),
# Android SDK 34 under /opt/homebrew/share/android-commandlinetools, and tools/venv (see README).
# Usage: TV_HOST=<tv ip> my-tv/xiaomi-mitv-mosr4/build-and-install.sh      or      my-tv/xiaomi-mitv-mosr4/build-and-install.sh <tv ip>
set -euo pipefail
cd "$(dirname "$0")/../.."
export TV_HOST="${1:-${TV_HOST:-}}" TV_ADB_BINARY="${TV_ADB_BINARY:-adb}"
[ -n "$TV_HOST" ] || { echo "usage: TV_HOST=<tv ip> $0, or $0 <tv ip>" >&2; exit 2; }
export JAVA_HOME="${JAVA_HOME:-/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home}"
export ANDROID_HOME="${ANDROID_HOME:-/opt/homebrew/share/android-commandlinetools}"
adb connect "$TV_HOST:5555" >/dev/null 2>&1 || true
launcher/build-and-install.sh
