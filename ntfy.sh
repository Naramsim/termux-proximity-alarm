#!/data/data/com.termux/files/usr/bin/bash

source config.env

curl -o /dev/null -sS -H "Priority: $1" -H "Title: $(date +'%d/%m %H:%M') $device_name $app_name $1" -d "$2" "ntfy.sh/$ntfy_topic"