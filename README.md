# Dotfiles

TODO: Set up ~/.config/git/config?
TODO: Create /opt/go/?
TODO: [](https://wiki.archlinux.org/title/simple_stateful_firewall)
netstat -plnt
TODO: net-tools is deprecated. What to use?
ss, ip route, route, iproute2, ip a

## Usage

* `sudo curl -fsLS tinyurl.com/dtdot | bash`

## Repository

* `config/`: User-level configuration.
* `docs/`
  * `misc.md`: A general collection of docs until further organization.
* `resources/`
  * `pacman_packages.txt`: Package list.
  * `pierre.asc.gpg`: The GPG key used to sign Arch Linux ISOs.
  * `pip_packages.txt`: Package list.
  * `secrets.7z`: A password-protected archive of SSH keys, passwords, etc.
* `scripts/`
  * `cleanup.sh`: System maintenance and removal of untracked files.
  * `common.sh`: What every healthy bash script should have.
  * `install.sh`: Arch Linux fresh install script #1.
  * `install_chroot.sh`: Arch Linux fresh install script #2.
  * `prepare.sh`: Prepare an Arch Linux install medium in `/dev/sdb`.
  * `secrets.sh`: Manage secrets during migrations.
* `system/`: System-wide configuration.

## Tasks

* Cooler packages: `ag`, `bat`, `delta`, `ripgrep`, `mdless`?
* AUR packages: `teams`, `spotify`?
* Fix: `gparted`, `flameshot`.
* Deployment and upgrade script.
* https://www.fosskers.ca/en/blog/wayland
* Battery charging limit, auto shutoff.
* Minimize battery usage, save all the power.
* grub.d and pacman.conf.d instead of patching?
* More details on printing with CUPS and CAPT.
* https://www.reddit.com/r/unixporn/comments/qjjhps
* https://github.com/natpen/awesome-wayland
* Gaming on Arch Linux!
* https://www.privacytools.io/
* https://www.youtube.com/watch?v=Z7p9-m4cimg

Configure rootless Docker.
```
echo "kernel.unprivileges_userns_clone=1" > /etc/sysctl.d/docker_rootless.conf
echo "$user:100000:65536" >> /etc/subuid
echo "$user:100000:65536" >> /etc/subgid
curl -fsSL https://get.docker.com/rootless | sh
```
