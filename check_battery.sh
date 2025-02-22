#!/data/data/com.termux/files/usr/bin/bash

if termux-battery-status | grep -q 'DISCHARGING'; then
  echo 'false' > charging.sensor
  percentage=$(termux-battery-status | grep 'percentage')
  percentage=${percentage%,*}
  percentage=${percentage#*:}
  if [ "$percentage" -lt 5 ] && [ "$(cat data/low_battery_notification_sent )" = 'false' ]; then
    ./ntfy.sh 'high' "Battery almost exhausted (${percentage}%)"
    echo true > data/low_battery_notification_sent
  fi
elif termux-battery-status | grep -q 'PLUGGED_USB'; then
  echo 'true' > data/charging.sensor
else
  echo 'false' > data/charging.sensor
fi
