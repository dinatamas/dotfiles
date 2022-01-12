#!/usr/bin/env bash

time=$(date +'%a %F %H:%M')
battery_status=$(cat /sys/class/power_supply/BAT0/capacity)

echo "$battery_status% ○ $time"
