# Sony BRAVIA KD-65X80J (65"), cleaned 25 October 2026

Google TV / Android 10, platform BRAVIA_VH2 (MediaTek MT5895), firmware QTG3.200305.006.S118. 3 GB RAM but
only 4 GB of `/data`. Everything below is reversible.

## What was done

| Step | Result |
|---|---|
| Backup | `backup/`: package lists, `getprop`, all settings, `dumpsys package` (before any change) |
| Debloat | Packages in `my-tv/sony-kd-65x80j/debloat.txt`: Samba TV, Sony device agents, Sony Select and the Sony tab, promos, retail demo and help, hotel mode, BRAVIA CAM leftovers, mirroring, the setup wizard. Nothing uninstalled. |
| Launcher | `com.gathin.tvhome` built from `launcher/` and set as Home; stock `com.google.android.apps.tv.launcherx` disabled |
| Kept | Google Assistant, Chromecast, the phone remote, Sony updates, Prime Video, Sony Media Player, HDMI-CEC (`braviasync*`), Live TV + inputs (`com.sony.dtv.tvx`), IR blaster and Quick Set |
| Not done | Ad-blocking DNS. Ambient mode and Living Decor left enabled. |

Home screen: dock Netflix, YouTube, Prime Video, Hotstar; top bar Inputs, network, Bluetooth, Settings
(no RAM pill on this set); 12-hour clock with the date under it. The dock, hidden tiles and pills come from
`config.json`, pushed with `tools/theme.sh`.

## Everyday things

- **Remote**: every button works with no key service. Netflix, YouTube, Prime Video and the mic button are
  handled by the firmware itself.
- **Storage**: `/data` is 4 GB and fills up. If an install fails with "not enough space",
  `tools/tv.py 'pm trim-caches 1G'` frees a few hundred MB.
- **Reboot**: `svc power reboot` is killed on this firmware; use `adb reboot`.
- **Firmware updates** stay on. After one, check for drift:
  `TV_HOST=<tv ip> TV_ADB_BINARY=adb tools/venv/bin/python -I tools/check.py my-tv/sony-kd-65x80j/debloat.txt com.gathin.tvhome`
  and add `--fix` to re-apply.
- **Before a factory reset**, run `my-tv/sony-kd-65x80j/restore.sh` first: the setup wizard must be enabled again.

## Re-enable any app

Connect once (`adb connect <tv ip>:5555`, USB debugging on the TV must be on), then:

```
adb shell pm enable --user 0 com.sony.dtv.sonyselect
```

Package names are the lines of `my-tv/sony-kd-65x80j/debloat.txt`. Comment the line out there too, so a later
re-apply leaves it alone.

## Change the dock, pills, clock or wallpaper

Edit `my-tv/sony-kd-65x80j/config.json` and push it: `TV_HOST=<tv ip> TV_ADB_BINARY=adb tools/theme.sh my-tv/sony-kd-65x80j`
(no rebuild). Keys are in `themes/README.md`. Anything that is `config.xml` only goes into
`launcher/app/src/main/res/values/config.xml`, then `my-tv/sony-kd-65x80j/build-and-install.sh` rebuilds and
reinstalls (about a minute) and pushes `config.json` again.

## Put everything back

```
TV_HOST=<tv ip> my-tv/sony-kd-65x80j/restore.sh
TV_HOST=<tv ip> tools/theme.sh --reset
```

Re-enables every package in `my-tv/sony-kd-65x80j/debloat.txt`, re-enables the stock Google TV launcher and
makes it Home. The new launcher stays installed but idle; remove it with `adb shell pm uninstall com.gathin.tvhome`.
