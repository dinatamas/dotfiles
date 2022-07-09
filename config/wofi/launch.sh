#!/usr/bin/env bash
#
# wofi application menu.
#
# The applist is from `/usr/share/applications/`
# and `~/.local/share/applications/`, but then
# it was manually edited.
#
applist="\
alacritty
chromium
code
discord
firefox --new-window
firefox --private-window
gimp
lutris
pavucontrol
qbittorrent
signal-desktop
steam
teams
thunar
vlc
zathura
"

# Place a launch_local.sh file in your ~/.config/wofi/ dir.
if [ -f ~/.config/wofi/launch_local.sh ]; then
    source ~/.config/wofi/launch_local.sh
    applist=$applist$applist_local
fi

selected=$(echo "$applist" \
    | wofi -aib \
        --width 500 \
        --dmenu \
        --lines 5 \
        --prompt  "" \
    | xargs swaymsg exec --)
