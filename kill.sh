#!/data/data/com.termux/files/usr/bin/bash

pkill -9 -f 'proximity.sh'
pkill -9 -f 'init.sh'
pkill -f grep
pkill -f tail
termux-sensor -c