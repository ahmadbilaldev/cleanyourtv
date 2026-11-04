# my-tv: the TVs in this household

One folder per set, each with the list that was applied (`debloat.txt`), a `restore.sh` that puts it back,
and, where the Clean Your TV launcher was installed, a `build-and-install.sh` and a `config.json` for the
dock, pills and clock. Everything was done with the repo's own tools, disable-only, as `PROMPT.md` says.
Backups, screenshots and working notes stay local (`backup/`, `shots/`, `work/` are in `.gitignore`).

| Folder | TV | OS | Launcher | Cleaned |
|---|---|---|---|---|
| `tcl-55c745/` | TCL 55C745, 55" (G08, MediaTek tcl9618) | Google TV 14 | yes, `InputKeyService` | 18 Oct 2026 |
| `sony-kd-65x80j/` | Sony BRAVIA KD-65X80J, 65" (BRAVIA_VH2, MediaTek) | Google TV 10 | yes | 25 Oct 2026 |
| `hisense-65e5h/` | Hisense 65E5H, 65" (hisense_m7642_cn, MediaTek MT9652) | JuUI 9 / Android 9 | no, debloat only | 27 Oct 2026 |
| `philips-55oled708/` | Philips 55OLED708/12, 55" (PH1M_WW_9972, MediaTek) | Google TV 12 | yes, `HomeKeyService` | 30 Oct 2026 |
| `xiaomi-mitv-mosr4/` | Xiaomi MiTV-MOSR4, 55" (irobot, MediaTek) | Google TV 11 | yes | 2 Nov 2026 |

The launcher in this branch has two small additions used on these sets, a Bluetooth pill that opens the
pairing screen and a RAM pill (`show_bluetooth_pill`, `show_ram_pill`), plus `BLUETOOTH_ADMIN` for the pairing
screen on Android 11. `launcher-changes.patch` is that diff against upstream `main`;
`launcher/app/src/main/res/values/config.xml` has the last set's build-time keys.

Every script takes the TV's address as `TV_HOST=<tv ip>` or as its first argument; nothing is hard-coded.
A set's README has the everyday notes: which remote buttons work, what was kept, how to re-enable one app,
and what to run before a factory reset.
