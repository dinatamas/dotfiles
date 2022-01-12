#!/usr/bin/env bash
#
# - /etc/NetworkManager/system-connections/*.nmconnection (root:root 0600)
#
# - /home/*/.ssh
#   chmod 700 /home/$user/.ssh
#   chmod 644 /home/$user/.ssh/authorized_keys
#   chmod 644 /home/$user/.ssh/known_hosts
#   chmod 644 /home/$user/.ssh/config
#   chmod 600 /home/$user/.ssh/id_ed25519
#   chmod 644 /home/$user/.ssh/id_ed25519.pub
#   chown -R $user:$user /home/$user/.ssh
#
# - /usr/share/background/dinatamas/
#
# - /usr/share/fonts/ttf-ms-win10/
#   Copy here your _legally_ obtained Windows 10 TTF files.
#   They should be owned by root:root, with 644 permissions.
#
#   For instructions on how to extract them from Windows, follow:
#   https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=ttf-ms-win10
#
#   Please note that the `ttf-ms-win10` package is not installed
#   as part of this setup, the files are simply copied over to
#   their corresponding place.
#   Additionally, `fc-cache -fv` should be run to update the fontconfig cache.
#
