#!/usr/bin/env bash
#
# Password-protected screenlock for sway.
#
#swayidle \
#    timeout 10 'swaymsg "output * dpms off"' \
#    resume 'swaymsg "output * dpms on"' &

# Locks the screen immediately.
swaylock -c 3b4252

# Kills last background task so idle timer doesn't keep running.
#kill %%
