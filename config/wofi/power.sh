#!/usr/bin/env bash
#
# wofi menu for power control.
#
entries="logoff\nshutdown\nreboot\n"

selected=$(printf $entries \
    | wofi -aib \
        --matching fuzzy \
        --width 500 \
        --height 160 \
        --prompt  "" \
        --dmenu \
        --cache-file /dev/null \
    | awk '{print tolower($1)}')

case $selected in
  logoff)
    exec swaymsg exit;;
  shutdown)
    exec shutdown now;;
  reboot)
    exec shutdown -r now;;
esac
