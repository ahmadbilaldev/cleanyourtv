# Hisense 65E5H (65"), cleaned 27 October 2026

JuUI 9 on Android 9, board hisense_m7642_cn (MediaTek MT9652), build PPR2.180905.006.A1, incremental
02.02.60.01. China-market set. Debloat only: the stock Home and Live TV stay. Everything below is reversible.

## What was done

| Step | Result |
|---|---|
| Backup | `backup/`: package lists, `getprop`, all settings, `dumpsys package` (before any change) |
| Debloat | 29 packages disabled (`my-tv/hisense-65e5h/debloat.txt`): ad SDK and service, telemetry, vendor push channel, store, hotel and demo apps, tutorials, preloaded content, the vendor screensaver, AI photo recognition, family album and cloud, message board, voice chat room. Nothing uninstalled. |
| Launcher | Not installed. The stock Home `com.jamdeo.tv.vod` and Live TV `com.jamdeo.tv.livetv` are untouched. |
| Kept | OTA updates, Bluetooth pairing, the source panel, voice input |
| Not done | Ad-blocking DNS. |

## Everyday things

- **ADB** on this firmware lives behind the factory menu (Settings → Sound → Advanced settings → Sound Balance,
  alternate OK and Menu until the **M** screen, ToFac from U to M, reboot, then Menu five times on the device
  information page reaches the native Android Settings and Developer options). Set ToFac back to U afterwards;
  M mode blocks the OTA check. The authorised ADB key survives the switch.
- **USB debugging off when done**: on this firmware it also leaves ADB open on port 5555 over Wi-Fi.
- **Reboot timing**: a reboot sooner than about a minute after `pm disable-user` can lose the state. Wait,
  reboot, then check `pm list packages -d`.
- **Firmware updates** stay on. After one, check for drift:
  `TV_HOST=<tv ip> TV_ADB_BINARY=adb tools/venv/bin/python -I tools/check.py my-tv/hisense-65e5h/debloat.txt`
  and add `--fix` to re-apply.

## Re-enable any app

Connect once (`adb connect <tv ip>:5555`, USB debugging on the TV must be on), then:

```
adb shell pm enable --user 0 com.hisense.tv.familyalbum
```

Package names are the lines of `my-tv/hisense-65e5h/debloat.txt`. Comment the line out there too, so a later
re-apply leaves it alone.

## Put everything back

```
TV_HOST=<tv ip> my-tv/hisense-65e5h/restore.sh
```

Re-enables every package in `my-tv/hisense-65e5h/debloat.txt`. Home was never changed.
