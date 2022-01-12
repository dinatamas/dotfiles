#!/usr/bin/env bash
#
# wofi application menu.
#
# The applist is from `/usr/share/applications/`
# and `~/.local/share/applications/`.
selected=$(cat ~/.config/wofi/applist.txt \
    | wofi -ai \
        --show dmenu \
        --lines 5 \
        --prompt  "" \
    | xargs swaymsg exec --)
