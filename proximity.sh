#!/data/data/com.termux/files/usr/bin/bash

declare -r hits_threshold=2
declare -r alarm_folder='./data'
declare -i hits=0
declare -i sensor_data_length=7
source config.env
declare -r sensor_filename="$alarm_folder/$(echo "$sensor_name" | tr -cd '[a-zA-Z0-9]._-').sensor"

if [ -f "$alarm_folder/alarm.pid" ]; then
  if ps --no-headers -p "$(cat $alarm_folder/alarm.pid)" >/dev/null 2>&1; then
    exit 0
  fi
fi
echo $BASHPID > "$alarm_folder/alarm.pid" # kill -2 $(cat data/alarm.pid)
./init.sh

function pic() {
  local -r picname="$(date '+%Y%m%d%H%M%S').jpg"
  termux-camera-photo -c 1 "$alarm_folder/pics/$picname"
  echo 'Pic taken'
  ./send_email_pic.sh "$alarm_folder/pics/$picname"
}

function rec() {
  local -r recname="$(date '+%Y%m%d%H%M%S').mp3"
  termux-microphone-record -e mp3 -l 0 -d -f "$alarm_folder/recs/$recname" >/dev/null 2>&1
  echo 'Recording started'
  sleep 20
  termux-microphone-record -q >/dev/null 2>&1
  echo 'Recording saved'
  ./send_email_rec.sh "$alarm_folder/recs/$recname"
}

function clean_exit() {
  termux-sensor -c >/dev/null 2>&1
  exit 0
}

function restart_sensor() {
  termux-sensor -c >/dev/null 2>&1
  echo '' > "$sensor_filename"
  sensor_data_length=$(termux-sensor -s "$sensor_name" -n1 | wc -l)
  termux-sensor -s "$sensor_name" -d 1000 > "$sensor_filename" 2>&1 &
  trap 'clean_exit' SIGINT
}

restart_sensor

while true; do
  if tail "-n${sensor_data_length}" "$sensor_filename" | grep -q -F -e ' 0'; then
    (( hits+=1 ))
    if [ "$hits" -gt $(( hits_threshold + 2 )) ]; then
      sleep 300
    fi
    if [ "$hits" -ge "$hits_threshold" ]; then
      if [ "$offline_scan" = 'true' ]; then
        ./enable_wifi.sh
      fi
      if [ "$(./is_nobody_home.sh)" = 'true' ]; then
        ./ntfy.sh 'high' 'Door open and nobody is home' &
        pic &
        rec &
      else
        ./ntfy.sh 'default' 'Door open but someone is at home'
      fi
      sleep 120
      if [ "$offline_scan" = 'true' ]; then
        ./enable_wifi.sh false
      fi
    fi
  else
    hits=0
  fi
  sleep 1
done
