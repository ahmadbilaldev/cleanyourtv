#!/usr/bin/env bash
# Rebuild the launcher after editing launcher/app/src/main/res/values/config.xml, reinstall it on the TV and
# push this folder's config.json over it (tools/theme.sh). Needs: adb (brew install --cask android-platform-tools),
# OpenJDK 21 (brew install openjdk@21), Android SDK 34 under /opt/homebrew/share/android-commandlinetools,
# and tools/venv (see README).
# Usage: TV_HOST=<tv ip> my-tv/philips-55oled708/build-and-install.sh      or      my-tv/philips-55oled708/build-and-install.sh <tv ip>
set -euo pipefail
cd "$(dirname "$0")/../.."
export TV_HOST="${1:-${TV_HOST:-}}" TV_ADB_BINARY="${TV_ADB_BINARY:-adb}"
[ -n "$TV_HOST" ] || { echo "usage: TV_HOST=<tv ip> $0, or $0 <tv ip>" >&2; exit 2; }
export JAVA_HOME="${JAVA_HOME:-/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home}"
export ANDROID_HOME="${ANDROID_HOME:-/opt/homebrew/share/android-commandlinetools}"
adb connect "$TV_HOST:5555" >/dev/null 2>&1 || true
HOME_KEY_SERVICE=1 launcher/build-and-install.sh
tools/theme.sh my-tv/philips-55oled708
