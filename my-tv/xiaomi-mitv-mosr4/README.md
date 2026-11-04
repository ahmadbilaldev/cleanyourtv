# Xiaomi MiTV-MOSR4 (55"), cleaned 2 November 2026

Google TV / Android 11, firmware RTM5.220609.003.1265. Everything below is reversible.

## What was done

| Step | Result |
|---|---|
| Backup | `backup/`: package lists, `getprop`, all settings, `dumpsys package` (before any change) |
| Debloat | 27 packages disabled (`my-tv/xiaomi-mitv-mosr4/debloat.txt`): Xiaomi analytics, ad rows, PatchWall, Mi TV+, TV Manager, demo mode, Miracast, Mi Music/Gallery/Video, Play Games, OTA updates, Google Assistant, the setup wizard. Nothing uninstalled. |
| Removed | iQIYI (an ordinary app, reinstall from the Play Store if you want it back) |
| Launcher | `com.gathin.tvhome` built from `launcher/` and set as Home; stock `com.google.android.apps.tv.launcherx` disabled |
| Kept | Chromecast built-in, Netflix key, Live TV + HDMI switching, Bluetooth/remote pairing, Play Store |
| Not done | Ad-blocking DNS (you said no). Remote gear button left dead (see below). |

Home screen: dock Netflix, YouTube, Prime Video, HBO Max (the fourth slot fills from the grid);
top bar Inputs, Wi-Fi name, Bluetooth (opens the pairing screen), RAM used %, Settings (gear icon);
12-hour clock with the date under it. Screenshots are in `shots/`.

## Everyday things

- **Remote**: YouTube, Netflix, Prime Video and Input buttons work. The **gear button does nothing**: on this
  model it goes through a Xiaomi key receiver that crashes once the stock launcher is off. You chose not
  to enable the launcher's key helper, because on this TV it stops the volume keys from ramping when held.
  To enable it later: `INPUT_KEY_SERVICE=1 HOME_KEY_SERVICE=1 my-tv/xiaomi-mitv-mosr4/build-and-install.sh`.
- **Mic button** does nothing: Google Assistant is disabled by your choice. Re-enable it with
  `adb shell pm enable --user 0 com.google.android.katniss`.
- **Firmware updates** are off by your choice. Re-enable: `adb shell pm enable --user 0 com.xiaomi.mitv.updateservice`
  (and `com.mitv.upgrader`, `com.mitv.ABUpdateStatus`). After an update, check for drift:
  `TV_HOST=<tv ip> TV_ADB_BINARY=adb tools/venv/bin/python -I tools/check.py my-tv/xiaomi-mitv-mosr4/debloat.txt com.gathin.tvhome`
  and add `--fix` to re-apply.
- **Before a factory reset**, run `my-tv/xiaomi-mitv-mosr4/restore.sh` first: the setup wizard must be enabled again.
- The Wi-Fi network saved during first setup was removed from the TV (it belonged to the setup wizard). Re-add it in
  Settings if you ever use it.

## Re-enable any app

Connect once (`adb connect <tv ip>:5555`, USB debugging on the TV must be on), then:

```
adb shell pm enable --user 0 com.google.android.play.games
```

Package names are the lines of `my-tv/xiaomi-mitv-mosr4/debloat.txt`. Comment the line out there too, so a later
re-apply leaves it alone. The grid shows the app again straight away.

## Change the dock, pills, clock or wallpaper

Edit `launcher/app/src/main/res/values/config.xml`, then run `my-tv/xiaomi-mitv-mosr4/build-and-install.sh` (about a
minute). The keys you are most likely to touch:

| Key | What it does | Now |
|---|---|---|
| `dock_apps` | Dock apps, in order | Netflix, YouTube, Prime Video |
| `columns` | Dock slots and grid columns (4 to 7) | 4 |
| `fill_dock` | Fill empty dock slots from the grid | true |
| `hidden_apps` | Apps never shown as tiles | Live TV, Gallery, Settings |
| `show_bluetooth_pill`, `show_ram_pill` | The two pills added for you | true |
| `icon_only_buttons`, `wifi_label_width` | Settings/Bluetooth as icons; Wi-Fi keeps its name up to N dp | true, 160 |
| `clock_format` | "12", "24" or "system" | 12 |
| `date_below_clock` | Date on its own line | true |
| `show_stats` | A CPU/memory/storage line under the clock | false |

Wallpaper and colours come from a theme, no rebuild needed: `TV_HOST=<tv ip> TV_ADB_BINARY=adb tools/theme.sh themes/aurora`
(folders in `themes/`, keys in `themes/README.md`; `tools/theme.sh --reset` removes it). A theme's `config.json`
can also set any key above, including `"show_bluetooth_pill"` and `"show_ram_pill"`.

The launcher source in this branch carries small changes shared by all the TVs in `my-tv/` (the two pills,
`BLUETOOTH_ADMIN` for the pairing screen). `my-tv/launcher-changes.patch` is the same diff against upstream `main`.

## Put everything back

```
my-tv/xiaomi-mitv-mosr4/restore.sh
```

Re-enables every package in `my-tv/xiaomi-mitv-mosr4/debloat.txt`, re-enables the stock Google TV launcher and makes it Home.
The new launcher stays installed but idle; remove it with `adb shell pm uninstall com.gathin.tvhome`.

## Tooling on this Mac

adb (`brew install --cask android-platform-tools`), OpenJDK 21 (`brew install openjdk@21`), Android SDK 34
in `/opt/homebrew/share/android-commandlinetools`, and the repo's Python venv (`python3 -m venv tools/venv &&
tools/venv/bin/pip install -r tools/requirements.txt`). `my-tv/xiaomi-mitv-mosr4/build-and-install.sh` exports the right
`JAVA_HOME` and `ANDROID_HOME`; the repo tools talk to the TV through `TV_ADB_BINARY=adb`.
