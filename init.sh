#!/data/data/com.termux/files/usr/bin/bash

declare -r folder_prefix='data'

mkdir -p "$folder_prefix/pics"
mkdir -p "$folder_prefix/recs"
rm -rf "$folder_prefix/pics/*"
rm -rf "$folder_prefix/recs/*"
rm -rf "$folder_prefix/*.sensor"
echo false > "$folder_prefix/low_battery_notification_sent"
termux-sensor -c >/dev/null 2>&1
sleep 60
./ntfy.sh 'high' 'Alarm armed'