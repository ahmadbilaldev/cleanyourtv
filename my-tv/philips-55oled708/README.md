# Philips 55OLED708/12 (55"), cleaned 30 October 2026

Google TV / Android 12, board PH1M_WW_9972 (TPV, MediaTek), firmware STT2.230831.001 build 20803. On Wi-Fi.
Everything below is reversible.

## What was done

| Step | Result |
|---|---|
| Backup | `backup/`: package lists, `getprop`, all settings, `dumpsys package` (before any change) |
| Debloat | Packages in `my-tv/philips-55oled708/debloat.txt`: TP Vision telemetry, Samba TV ACR, Philips and Google promos, NFT Collection, Play-Fi, Control4, Matter, Mimi, Alexa, the Philips launcher tab, the setup wizard. Nothing uninstalled. |
| Launcher | `com.gathin.tvhome` built from `launcher/` with `HOME_KEY_SERVICE=1` and set as Home; stock `com.google.android.apps.tv.launcherx` disabled |
| Kept | AirPlay, Google Assistant, firmware updates, DLNA, Ambilight, Multi View, Live TV + inputs (`org.droidtv.playtv`, `com.mediatek.tis`), `org.droidtv.demome` (holds TV_INPUT_HARDWARE, so `disable.sh` refuses it) |
| Not done | Ad-blocking DNS. The Vewd browser and BrowseHere left enabled. |

Home screen: dock Netflix, YouTube, HBO Max, Apple TV (no fill); top bar Inputs, Wi-Fi, Bluetooth, RAM used %,
Settings; 24-hour clock with the date under it. The dock, hidden tiles, pills and the Apps button come from
`config.json`, pushed with `tools/theme.sh`.

## Everyday things

- **Remote**: Sources, Netflix, YouTube, TV and Quick menu are handled by the firmware and keep working. The
  **gear and Apps buttons** go through `org.droidtv.GlobalKey`, which hard-codes them to the stock launcher, so
  the launcher's `HomeKeyService` answers them: the Apps button (keycode 813) from `app_keys` in `config.json`,
  the gear by scancode 141, which is `config.xml` only (`settings_key_scancodes`), so it is set before the build.
  Press the real buttons after a rebuild; an injected key does not go through GlobalKey.
- **Setup wizard** (`com.google.android.tungsten.setupwraith`) is disabled: it owned the Wi-Fi saved at first
  setup, so the network was forgotten and re-joined in Settings first, then `FORCE_SETUPWRAITH=1`.
- **Firmware updates** stay on. After one, check for drift:
  `TV_HOST=<tv ip> TV_ADB_BINARY=adb tools/venv/bin/python -I tools/check.py my-tv/philips-55oled708/debloat.txt com.gathin.tvhome`
  and add `--fix` to re-apply.
- **Before a factory reset**, run `my-tv/philips-55oled708/restore.sh` first: the setup wizard must be enabled again.

## Re-enable any app

Connect once (`adb connect <tv ip>:5555`, USB debugging on the TV must be on), then:

```
adb shell pm enable --user 0 org.droidtv.oemtabprovider
```

Package names are the lines of `my-tv/philips-55oled708/debloat.txt`. Comment the line out there too, so a later
re-apply leaves it alone.

## Change the dock, pills, clock or wallpaper

Edit `my-tv/philips-55oled708/config.json` and push it: `TV_HOST=<tv ip> TV_ADB_BINARY=adb tools/theme.sh my-tv/philips-55oled708`
(no rebuild). Keys are in `themes/README.md`. Anything that is `config.xml` only (the gear scancode) goes into
`launcher/app/src/main/res/values/config.xml`, then `my-tv/philips-55oled708/build-and-install.sh` rebuilds and
reinstalls (about a minute) and pushes `config.json` again.

## Put everything back

```
TV_HOST=<tv ip> my-tv/philips-55oled708/restore.sh
TV_HOST=<tv ip> tools/theme.sh --reset
```

Re-enables every package in `my-tv/philips-55oled708/debloat.txt`, re-enables the stock Google TV launcher and
makes it Home. The new launcher stays installed but idle; remove it with `adb shell pm uninstall com.gathin.tvhome`.
