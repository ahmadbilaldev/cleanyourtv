# TCL 55C745 (55"), cleaned 18 October 2026

Google TV / Android 14, device G08 (`G08_4K_GB`, MediaTek tcl9618), firmware UTT2.250416.001 AU02. On
Ethernet, no saved Wi-Fi. Everything below is reversible.

## What was done

| Step | Result |
|---|---|
| Backup | `backup/`: package lists, `getprop`, all settings, `dumpsys package` (before any change) |
| Debloat | 48 app packages disabled (`my-tv/tcl-55c745/debloat.txt`): TCL promo/push/demo, account, cleaner, log capture, Android 14 ad and privacy services, duplicate webviews, USB media player, UK catch-up apps. Nothing uninstalled. |
| Launcher | `com.gathin.tvhome` built from `launcher/` and set as Home; stock `com.google.android.apps.tv.launcherx` and the setup wizard disabled afterwards |
| Kept | Chromecast, voice search, Miracast and MagicConnect, Live TV + HDMI switching (`com.tcl.tv`), the Source key QuickPanel (`com.tcl.suspension`), remote pairing, the TCL keyboard, Play Store, firmware updates |
| Not done | Ad-blocking DNS. `com.tcl.eva` left as the list has it (disabled); no camera is attached. |

Home screen: dock Netflix, YouTube, Prime Video (the fourth slot fills from the grid); top bar Inputs,
network, Bluetooth, RAM used %, Settings; 12-hour clock with the date under it. The dock, hidden tiles and
pills come from `config.json`, pushed with `tools/theme.sh`.

## Everyday things

- **Remote**: Home, Input, Netflix, YouTube and Prime Video buttons work. The Input button goes through
  `fusion`-style TCL key handling, so the launcher's `InputKeyService` is on (`INPUT_KEY_SERVICE=1` in
  `build-and-install.sh`). If a button ever stops answering, `adb shell am force-stop com.gathin.tvhome`
  switches the helper off and a reboot brings it back.
- **Setup wizard** (`com.google.android.tungsten.setupwraith`) is disabled: the set is on Ethernet, so it owned
  no Wi-Fi network. If the TV ever moves to Wi-Fi, re-enable the wizard first or the network setup screen
  does not open: `adb shell pm enable --user 0 com.google.android.tungsten.setupwraith`.
- **Firmware updates** stay on. After one, check for drift:
  `TV_HOST=<tv ip> TV_ADB_BINARY=adb tools/venv/bin/python -I tools/check.py my-tv/tcl-55c745/debloat.txt com.gathin.tvhome`
  and add `--fix` to re-apply. The stock launcher comes back enabled after some updates; `--fix` handles it.
- **Before a factory reset**, run `my-tv/tcl-55c745/restore.sh` first: the setup wizard must be enabled again.

## Re-enable any app

Connect once (`adb connect <tv ip>:5555`, USB debugging on the TV must be on), then:

```
adb shell pm enable --user 0 com.tcl.usercenter
```

Package names are the lines of `my-tv/tcl-55c745/debloat.txt`. Comment the line out there too, so a later
re-apply leaves it alone.

## Change the dock, pills, clock or wallpaper

Edit `my-tv/tcl-55c745/config.json` and push it: `TV_HOST=<tv ip> TV_ADB_BINARY=adb tools/theme.sh my-tv/tcl-55c745`
(no rebuild). Keys are in `themes/README.md`. Anything that is `config.xml` only goes into
`launcher/app/src/main/res/values/config.xml`, then `my-tv/tcl-55c745/build-and-install.sh` rebuilds and
reinstalls (about a minute) and pushes `config.json` again.

## Put everything back

```
TV_HOST=<tv ip> my-tv/tcl-55c745/restore.sh
TV_HOST=<tv ip> tools/theme.sh --reset
```

Re-enables every package in `my-tv/tcl-55c745/debloat.txt`, re-enables the stock Google TV launcher and makes
it Home. The new launcher stays installed but idle; remove it with `adb shell pm uninstall com.gathin.tvhome`.
