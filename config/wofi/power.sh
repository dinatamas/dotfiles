#!/usr/bin/env bash
#
# wofi menu for power control.
#

entries="logoff\nshutdown\nreboot\n"

selected=$(printf $entries \
    | wofi -ai \
        --width 250 \
        --prompt  "" \
        --lines 3 \
        --dmenu \
        --cache-file /dev/null \
    | awk '{print tolower($1)}')

echo $selected > /tmp/selected.txt

case $selected in
  logoff)
    exec swaymsg exit;;
  shutdown)
    exec shutdown now;;
  reboot)
    exec shutdown -r now;;
esac
