# Termux proximity alarm

Use your old Android phone as an alarm to detect open ports/windows. Phone proximity sensors can usually detect if an object is farther or closer than 5cm. By using this sensor we can detect when ports or windows are open by placing the phone 90 degrees from a closed door. We can then connect to our router and check if any house-member devices are connected and if not send a notification through Wifi, Ntfy and Gmail to selected recipients including a picture and a short recording.

You can use this code as it is or as a boilerplate to interact with other sensors to detect potential thieves.

### Requirements

- An Android phone
- Developer options/USB debugging enabled
- termux, termux-api, termux-boo installed and configured
  - https://github.com/termux/termux-app/releases
  - https://github.com/termux/termux-api/releases
  - https://github.com/termux/termux-boot/releases
  - `adb install `
- Open at least once termux and termux-boot
- Give camera and mic permissions to termux-api
- Identify the proximity sensor name with `termux-sensor -l`. It should return `0` or `5`

### Install

Copy this repo to `/data/user/0/com.termux/files/home`.

```sh
# Fill bootsrap.sh
bash bootstrap.sh
# cat alarm.cron
crontab -e
# reboot your phone and unlock
# profit
```

### Prolong battery span

Install https://github.com/RikkaApps/Shizuku/releases and https://github.com/samolego/Canta/releases to remove bloatware. Open Shizuku

```sh
adb shell 'sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh'
```

Allow Canta, open it and uninstall.

Remove all permissions from Google Play services, even the one for modifying system settings.

### Other detection methods not implemented

- Lean the phone on the door. Use `Tilt detector` sensor to detect its fall