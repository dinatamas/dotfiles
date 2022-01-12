#!/usr/bin/env bash
#
# This is a convenience script for preparing
# the Arch Linux installation medium.
#
source /opt/repo/dotfiles/scripts/common.sh || exit 1

_dt_ensure_root

release=$(date -d '' '+%Y.%m.01')
file="archlinux-${release}-x86_64.iso"
server='https://ftp.spline.inf.fu-berlin.de/mirrors'

tmpdir=$(_dt_tmpdir)
cd "${tmpdir}"

_dt_cleanup() {
    rm "${file}" "${file}.sig" 'sha1sums.txt'
}

wget "${server}/archlinux/iso/${release}/${file}" -O "${file}"
wget "${server}/archlinux/iso/${release}/sha1sums.txt" -O 'sha1sums.txt'
sed -i "/${file}/!d" 'sha1sums.txt'
sha1sum -c 'sha1sums.txt'

wget "https://archlinux.org/iso/${release}/${file}.sig" -O "${file}.sig"
gpg --no-default-keyring \
    --keyring '/opt/repo/dotfiles/resources/pierre.asc.gpg' \
    --verify "${file}.sig" "${file}"
# The public key was retrieved from the archlinux keyring:
# https://gitlab.archlinux.org/archlinux/archlinux-keyring/
# It was converted to OpenPGP format with: `gpg --dearmor pierre.asc`

if grep -qs '/dev/sdb' '/proc/mounts'; then
    exit 'The USB device must not be mounted'
    exit 3
fi

parted '/dev/sdb' --script -- mklabel gpt
parted '/dev/sdb' --script -- mkpart primary ext4 0% 100%
mkfs.ext4 -F '/dev/sdb1'
dd bs='4M' if="./${file}" of='/dev/sdb' status='progress' oflag='sync'
