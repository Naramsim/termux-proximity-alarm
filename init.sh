#!/data/data/com.termux/files/usr/bin/bash

declare -r folder_prefix='data'
source config.env

mkdir -p "$folder_prefix/pics"
mkdir -p "$folder_prefix/recs"
rm -rf "$folder_prefix/pics/*"
rm -rf "$folder_prefix/recs/*"
rm -rf "$folder_prefix/*.sensor"
echo false > "$folder_prefix/low_battery_notification_sent"
termux-sensor -c >/dev/null 2>&1
sleep 60
if [ "$offline_scan" = 'true' ]; then
  ./enable_wifi.sh
fi
./ntfy.sh 'high' 'Alarm armed'
if [ "$offline_scan" = 'true' ]; then
  ./enable_wifi.sh false
fi