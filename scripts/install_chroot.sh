#!/bin/bash
#
# This is the second phase of the installation.
# It is run within a chroot system on the new installation.
#
source /opt/repo/dotfiles/scripts/common.sh || exit 1

if [ $# -gt 0 ]; then
    cat << EOM
This script is not intended to be run manually.
Please use install1.sh instead.
EOM
    exit 0
fi

user=dinatamas

echo "Entering chroot..."

echo "Performing system configuration..."
_dt_ask_proceed
loadkeys hu
timedatectl set-ntp true
ln -sf /usr/share/zoneinfo/Europe/Budapest /etc/localtime
hwclock --systohc

echo "Copying system files..."
_dt_ask_proceed
rsync -r /opt/repo/dotfiles/system/* /
patch -N /etc/default/grub /etc/default/grub.patch || true
patch -N /etc/pacman.conf /etc/pacman.conf.patch || true

echo "Generating locales..."
_dt_ask_proceed
locale-gen

echo "Installing and configuring GRUB..."
_dt_ask_proceed
mkdir -p /efi
mount /dev/sda1 /efi
grub-install \
    --target=x86_64-efi \
    --efi-directory=/efi \
    --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "Setting root password..."
_dt_ask_proceed
passwd

echo "Creating new user called ${user}..."
_dt_ask_proceed
mkdir /home/$user
useradd $user
chown -R $user:$user /home/$user
chown -R $user:$user /opt/repo/dotfiles
chown -R $user:$user /opt/dinatamas

echo "Setting the password for new user..."
_dt_ask_proceed
passwd $user

echo "Copying configuration files..."
_dt_ask_proceed
mkdir -p /home/$user/.config
chown $user:$user /home/$user/.config
rsync -pr /opt/repo/dotfiles/config/* /home/$user/.config/

echo "Configuring sudo..."
_dt_ask_proceed
groupadd sudo
usermod -aG sudo $user

echo "Setting main shell to fish..."
_dt_ask_proceed
chsh -s `which fish` $user

echo "Enabling the NetworkManager service"
_dt_ask_proceed
systemctl enable NetworkManager

echo "Installing additional packages"
git clone https://github.com/VundleVim/Vundle.vim.git \
    /home/dinatamas/.config/nvim/bundle/Vundle.vim
vim +PluginInstall +qall
pip install -U -r 'resources/pip_packages.txt'

/opt/repo/dinatamas/secrets.sh extract

git -C '/opt/repo/dotfiles' remote set-url \
    origin 'git@github.com:dinatamas/dotfiles.git'
