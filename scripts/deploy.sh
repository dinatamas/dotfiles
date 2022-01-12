#!/usr/bin/env bash
#
# Clone the dotfiles repository and deploy
# its contents to a completely empty system.
#

if [ "${EUID}" -ne 0 ]; then
    echo 'Please run this script as root' 1>&2
    exit 1
fi

mkdir -m 1777 /opt/repo /var/log/dinatamas
git clone https://github.com/dinatamas/dotfiles /opt/repo/dotfiles

source /opt/repo/dotfiles/scripts/common.sh || exit 1

# docs -> /usr/share/doc/dinatamas
# config/* -> /home/dinatamas/.config/*
