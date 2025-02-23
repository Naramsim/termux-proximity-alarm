# Termux proximity alarm

Use your old Android phone as an alarm to detect open ports/windows.

Phone proximity sensors can usually detect if an object is farther or closer than 5cm. By using these sensors we can detect when ports or windows are open by placing the phone 90 degrees from a closed door. When the door is opened the proximity sensor will trigger. To greatly reduce false positives we can then check if no one is at home (and thus the door was opened by someone we don't know) by connecting to our router and check if house-member devices are connected or not. In the latter case, send a notification on [Ntfy](https://docs.ntfy.sh/) and email to selected recipients including a picture and a short recording of what's going on. Hopefully this can alert you if an intrusion is happening.

https://github.com/user-attachments/assets/41cdeaf0-ea76-45d1-88e4-8316af49f9d7

> [!IMPORTANT]
> You can use this code as-is or as a boilerplate to interact with other phone-sensors to detect potential burglars. Most probably you will need to modify part of the code to better suit your needs. Please review the code before opening issues

### Requirements

- An Android phone
- Developer options/USB debugging enabled
- termux, termux-api, termux-boot installed and configured
  - https://github.com/termux/termux-app/releases
  - https://github.com/termux/termux-api/releases
  - https://github.com/termux/termux-boot/releases
  - `adb install ...apk`
- Open at least once termux and termux-boot
- Give camera and mic permissions to termux-api
- Identify the proximity sensor name with `termux-sensor -l`. It should return `0` or `5`

### Install

Copy this repo to `/data/user/0/com.termux/files/home/`.

```sh
cp config.sample.env config.env
# edit config.env
bash bootstrap.sh # Or review/execute each command by hand
# cat alarm.cron
crontab -e # Decide when the alarm should run. By default it runs on boot and there's no need to start it by cron
# reboot your phone and unlock it
# check if something is working, else open an issue/debug
```

### Config

`config.env` customizable properties:

| Key | Value |
| --- | --- |
| app_name | `android-alarm` |
| device_name | A name to identify which phone you are using |
| ntfy_topic | A [ntfy.sh](https://docs.ntfy.sh/) topic to publish messages to |
| gmail_auth | A string `email:pass` used to send emails. `pass` has to be an [app pasword](https://support.google.com/mail/answer/185833?hl=en) if you use Gmail |
| sensor_name | By running `termux-sensor -l` you should understand which is the codename for your proximity sensor. Then save it here |
| router_user | Username of your router |
| router_pass | Password of your router |
| our_devices | Space separated home-members devices to look for in the router state. You should list here all the phones that are normally attached to the Wifi |
| offline_scan | `true` or `false`, whether to constantly have Wifi enabled or disabled |
| mail1_subject | Subject text of the first mail sent when a detection is fired |
| mail1_object | Object text of the first mail |
| mail2_subject | Subject text of the second mail |
| mail2_object | Object text of the second mail |
| mail_rcpt | Comma and space separated email recipients |

### Lifecycle

By adding a file under `~/.termux/boot` we start `sshd`, `crond` and the alarm when the phone boots. The phone then waits 60s and arms itself. The proximity sensor is read every 1s and if for more than two consecutive occurences the value reports an open door then we connect to our router page and check if `our_devices` devices are connected. If all of those are not present, no one is at home and probably the door was opened by a burglar. We then fire a notification on Ntfy and send first an email with attached a picture for us to review and secondly a 20s recording. Then the alarm sleeps for 120s and resumes its normal functioning.

### Prolong battery span

Install https://github.com/RikkaApps/Shizuku/releases and https://github.com/samolego/Canta/releases to remove bloatware. Open Shizuku,

```sh
adb shell 'sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh'
```

Allow Canta, open it and uninstall unneccessary services.

Remove all permissions from Google Play services, even the hidden modify-system-settings' one.

Set `offline_scan` property to `true` so to have Wifi turned on and off when detections occur.

Use `cron` to schedule the timing for your alarm.

### Gotchas

- The router connection phase is customized for my Sky router. If you own a different router you'll need to rewrite the logic of `is_nobody_home.sh` file.
- If the alarm stops working, most probably your Android OS is killing Termux or the alarm process. Check out https://dontkillmyapp.com/ to find ways to stop it from doing so. Alternatively you can instruct a frequent cronjob to keep the service alive or play with [termux-job-scheduler](https://wiki.termux.com/wiki/Termux-job-scheduler)

### Other detection methods not implemented

- Lean the phone on the door. Use `Tilt detector` sensor to detect its fall
- If you have a sliding door, use `Proxmity sensor` to detect when it slides open
