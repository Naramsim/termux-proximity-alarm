#!/data/data/com.termux/files/usr/bin/bash

source config.env

if termux-battery-status | grep -q 'DISCHARGING'; then
  echo 'false' > data/charging.sensor
  percentage=$(termux-battery-status | grep 'percentage')
  percentage=${percentage%,*}
  percentage=${percentage#*:}
  if [ "$percentage" -lt 5 ] && [ "$(cat data/low_battery_notification_sent )" = 'false' ]; then
    if [ "$offline_scan" = 'true' ]; then
      ./enable_wifi.sh
    fi
    ./ntfy.sh 'high' "Battery almost exhausted (${percentage}%)"
    echo true > data/low_battery_notification_sent
    if [ "$offline_scan" = 'true' ]; then
      ./enable_wifi.sh false
    fi
  fi
elif termux-battery-status | grep -q 'PLUGGED_USB'; then
  echo 'true' > data/charging.sensor
else
  echo 'false' > data/charging.sensor
fi
