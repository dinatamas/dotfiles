# Dotfiles

## Usage

* `sudo curl -fsLS tinyurl.com/dtdot | bash`

## Repository

* `config`: User-level configuration.
* `docs`
  * `misc.md`: A general collection of docs until further organization.
* `resources`
  * `pacman_packages.txt`: Package list.
  * `pierre.asc.gpg`: The GPG key used to sign Arch Linux ISOs.
  * `pip_packages.txt`: Package list.
* `scripts`
  * `common.sh`: What every healthy bash script should have.
  * `deploy.sh`: Single script to deploy the dotfiles on a system.
  * `install1.sh`: 
  * `install2.sh`: 
  * `prepare.sh`: Prepare an Arch Linux install medium in `/dev/sdb`.
  * `secret.sh`: Manage secrets during migrations.
* `system`: System-wide configuration.

## Tasks

* `etc defaults grub` should be a patch instead!
