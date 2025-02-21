#!/data/data/com.termux/files/usr/bin/bash

declare -r csfr_token='fbiqjz6uvu'
source config.env
#our_devices='test not-existent nokia'

function logout() {
  curl -o /dev/null -sSk 'https://192.168.0.1/home_loggedout.jst' -H "Cookie: DUKSID=$cookie; csrfp_token=$csfr_token"
}

output=$(curl -sSk -D - 'https://192.168.0.1/check.jst' -H "Cookie: DUKSID=jst_sessTYp5qyUBfj99YT7eNH3sjs21cU6S2604; csrfp_token=$csfr_token" --data-raw "username=$router_user&password=$router_pass&locale=it" | grep 'DUKSID')
cookie="${output:19:40}"
if [ -z "$output" ]; then
  ./ntfy.sh 'default' 'Cannot login or read cookie from Router login page'
fi

output=$(curl -sSk 'https://192.168.0.1/connected_devices_computers.jst' -H "Cookie: DUKSID=$cookie; csrfp_token=$csfr_token" | grep -F 'var onlineHostNameArr = [')
if [ -n "$output" ]; then
  for device in $our_devices; do
    if echo "$output" | grep -q "$device"; then
      logout
      echo "false"
      exit 0
    fi
  done
else
  ./ntfy.sh 'default' 'Cannot get list of connected devices from Router'
  exit 1
fi

logout
echo 'true'
exit 0