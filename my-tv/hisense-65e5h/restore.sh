#!/usr/bin/env bash
# Put the TV back the way it was: re-enables every disabled package, re-enables the stock launcher
# and makes it Home again. The new launcher stays installed (uninstall: pm uninstall com.gathin.tvhome).
# Usage: TV_HOST=<tv ip> my-tv/hisense-65e5h/restore.sh      or      my-tv/hisense-65e5h/restore.sh <tv ip>
set -euo pipefail
cd "$(dirname "$0")/../.."
export TV_HOST="${1:-${TV_HOST:-}}" TV_ADB_BINARY="${TV_ADB_BINARY:-adb}"
[ -n "$TV_HOST" ] || { echo "usage: TV_HOST=<tv ip> $0, or $0 <tv ip>" >&2; exit 2; }
adb connect "$TV_HOST:5555" >/dev/null 2>&1 || true
tools/restore.sh my-tv/hisense-65e5h/debloat.txt 
