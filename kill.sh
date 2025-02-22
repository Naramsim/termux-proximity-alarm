#!/data/data/com.termux/files/usr/bin/bash

termux-sensor -c
pkill -9 -f 'proximity.sh'
pkill -9 -f 'init.sh'
pkill -f grep
pkill -f tail
pkill -f sleep