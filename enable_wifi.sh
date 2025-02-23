#!/data/data/com.termux/files/usr/bin/bash

function force_wifi() {
  termux-wifi-enable false
  sleep 2
  termux-wifi-enable true
  termux-wifi-enable true
  sleep 20
}

termux-wifi-enable "${1:-true}" >/dev/null 2>&1

if [ "${1:-true}" = 'true' ]; then
  declare -r max_wait=14
  declare -i counter=0
  until termux-wifi-connectioninfo | grep 'supplicant_state' | grep -q 'COMPLETED'; do
    ((counter+=1))
    if [ "$counter" -ge "$max_wait" ]; then
      force_wifi
      exit 1
    fi
    sleep 1
  done
  sleep 1
fi