#!/bin/bash
#
# This is the first installation script.
# Run this in the Arch live environment.
#

_dt_cleanup () {
    echo "Exiting..."
    umount /mnt || true
    umount /mnt/efi || true
    swapoff /dev/sda2
    exit 0
}

if [ $# -gt 0 ]; then
    cat << EOM
Start this script in the initial archlinux virtual console.
Please make sure to read through the README.
EOM
    exit 0
fi

echo "Initial installation"
pacman -Sy archlinux-keyring git rsync
mkdir -p -m 1777 /opt/repo /var/log/dinatamas /tmp/dinatamas
git clone https://github.com/dinatamas/dotfiles.git /opt/repo/dotfiles

source /opt/repo/dotfiles/scripts/common.sh || exit 1

echo "Verifying that the computer has network connectivity..."
ping archlinux.org -c 2
if [ $? -ne 0 ]; then
    echo "Error: No network connectivity!"
    exit 1
fi

echo "Loading keyboard layout..."
loadkeys hu

echo "Verifying that the system was booted in UEFI mode..."
ls /sys/firmware/efi/efivars &> /dev/null
if [ $? -ne 0 ]; then
    echo "Warning: The system wasn't booted in UEFI mode!"
    _dt_ask_proceed
fi

echo "Backing up current partition layout to sda.dump..."
sfdisk --dump /dev/sda > sda.dump

echo "Creating new partition layout..."
echo "If you proceed, all data will be erased from sda."
_dt_ask_proceed
read -r -d '' sfdisk_script << EOM || true
label: gpt
/dev/sda1 : size=500MiB type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B
/dev/sda2 : size=4GiB type=0657FD6D-A4AB-43C4-84E5-0933C84B4F4F
/dev/sda3 : type=4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709
EOM
echo "$sfdisk_script" | sfdisk --wipe always /dev/sda

echo "Creating new filesystems..."
_dt_ask_proceed
mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 /dev/sda3

echo "Mounting new filesystems..."
mkdir -p /mnt/efi
mount /dev/sda1 /mnt/efi
swapon /dev/sda2
mount /dev/sda3 /mnt

echo "Generating new mirror file..."
curl -S -o ./mirrorlist "https://archlinux.org/mirrorlist/?country=DE&protocol=https&ip_version=4&use_mirror_status=on"
sed -i 's/#Server/Server/g' ./mirrorlist
mv ./mirrorlist /etc/pacman.d/mirrorlist

echo "Installing packages..."
packagelist=$(sed 's:#.*$::g' ../resources/pacman_packages.txt | tr '\n' ' ')
# TODO: https://wiki.archlinux.org/title/Pacman/Tips_and_tricks
# To generate a list of currently installed packages:
# pacman -Qe | awk '{print $1}' > pacman_packages.txt
pacstrap /mnt $packagelist

echo "Generating fstab file..."
_dt_ask_proceed
genfstab -U /mnt >> /mnt/etc/fstab

echo "Copying resource and environment files..."
_dt_ask_proceed
mkdir -p -m 1777 /mnt/opt/repo/
rsync -r /opt/repo/dotfiles/ /mnt/opt/repo/dotfiles/

echo "Executing install2.sh in chroot..."
_dt_ask_proceed
arch-chroot /mnt /bin/bash -c "/opt/repo/dotfiles/scripts/install_chroot.sh"

echo "Done!"
echo "Please reboot."
_dt_ask_proceed
# TODO: Cleanup the dotfiles dir.
