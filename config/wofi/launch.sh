#!/usr/bin/env bash

#
# wofi application menu.
#
# The applist is from `/usr/share/applications/`
# and `~/.local/share/applications/`, but then
# it was manually edited.
# Also see `pacman -Qqe` for installed packages.
#
applist="\
alacritty
chromium
discord
firefox --new-window
firefox --private-window
lutris
pavucontrol
qbittorrent
signal-desktop
spotify
steam
teams
thunar
vlc
"

selected=$(echo "$applist" \
    | wofi -aib \
        --matching fuzzy \
        --width 500 \
        --height 260 \
        --dmenu \
        --prompt  "" \
    | xargs swaymsg exec --)
