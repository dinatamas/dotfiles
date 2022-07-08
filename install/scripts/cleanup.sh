#!/usr/bin/env bash
#
# Perform system maintenance.
#
# https://wiki.archlinux.org/title/System_maintenance
# Other tasks, not implemented here:
#  - Check system logs for errors
#  - Check the disk: df -ha and ncdu
#  - Update GPG keys: sudo pacman -S archlinux-keyring
#  - Update the system: sudo pacman -Syu
#  - Find broken symlinks: find / -xtype l -print
#  - Find largest pkgs: expac -HM '%m %n' | sort -n | tail
#
source /opt/repo/dotfiles/scripts/common.sh || exit 1

_dt_ensure_root

# Remove ephemeral directory content.
rm -rf '/var/log/dinatamas/*'
rm -rf '/tmp/dinatamas/*'

# Clean dotfiles repository.
git -C '/opt/repo/dotfiles/' clean -dfX

# Remove orphan packages.
pacman -Qtdq | pacman --noconfirm -Rns - || true

# Clean pacman cache.
pacman --noconfirm -Sc

# Docker garbage collection.
# Full cleanup: docker system prune -af --volumes
systemctl start docker
docker system prune -f --volumes

# Clean caches.
# Manually: ~/.cache -> pip, mozilla, chromium
rm -f '/home/dinatamas/.local/share/nvim/swap/*'
rm -rf '/home/dinatamas/.local/share/virtualenv/'
