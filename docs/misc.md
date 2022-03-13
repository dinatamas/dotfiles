# Miscellaneous docs

## Bash scripting guide

This document contains the information and guidelines with which
I write my bash scripts. It also contains some usage information
about the helper utilities in `opt/dinatamas/`.

Base reference: https://google.github.io/styleguide/shellguide.html

* Use bash variables like this: `"${varname}"`
* Quote literals / params with sinqle quotes.
* Add `/` to the end of directories (when it makes no difference).

* Prefix sort-of-private variables / functions with `__dt_`.
* Prefix sort-of-public variables / functions with `_dt_`.

* Use `varname="<text with newlines>"` to retain the newlines, and
  `read -r -d '' varname <<'EOF' || true <text with newlines> EOF` to not.

## Utilities

* Other TTYs can be opened up with `Ctrl+Alt+F<n>`
* Hold `Shift` to open GRUB menu during bootup.
* Networking: `nmtui`
* Battery status from command line: `battery`
* PDF manipulation: `pdftk`, `pandoc`
* PDF viewing: `zathura`
  * https://defkey.com/zathura-shortcuts
* Image viewing: `feh`
* Docker cleanup: `docker system prune -af --volumes`
* Copy-paste instructions:
  * Alacritty:
    * Select using the mouse.
    * `Ctrl+Shift+c` copies, `Ctrl+Shift+v` pastes.
  * Tmux (mostly over SSH):
    * `Ctrl+b` then `[`.
    * Navigate using arrows, select using space.
    * Copy using `Alt+w`.
    * Paste using `Ctrl+b` then `]`.
  * Emacs:
    * `Ctrl+Space` to select text.
    * `Alt+w` copies, `Ctrl+w` cuts, `Ctrl+y` pastes.
  * Vim:
    * `v` for visual, `Ctrl+v` for visual block selection.
    * `y` copies, `d` cuts, `p` pastes.
* Bluetooth:
  * To start:
    * `systemctl start bluetooth`
    * `bluetoothctl power on`
  * To connect:
    * `bluetoothctl scan on`
    * `bluetoothctl pair <MAC>`
    * `bluetoothctl connect <MAC>`
  * To finish:
    * `bluetoothctl power off`
    * `systemctl stop bluetooth`
* Screenshot: `flameshot`
* Background tasks: `&`, `nohup`, `disown`, `jobs`
* Connect to the Internet (in the Archlinux ISO):
  * Ethernet and USB tethering should work out-of-the-box.
  * For wifi run `iwctl` and the following commands:
    1. `device list`
    1. `station <wlan ID> get-networks`
    1. `station <wlan ID> connect <SSID>`
* Get detailed hardware info: `dmidecode`
  * For battery: check `/sys/class/power_supply/BAT0/`
* Pendrive management in Linux:
  * Locate: `fdisk -l` or `findmnt`
  * Locate: `df`, make sure not mounted (`umount /dev/sdb1`)
  * Check filesystem: `fsck /dev/sdb1`
  * Create (format) the filesystem: `mkfs.ntfs /dev/sdb1`
    * Or to skip writing zeros and checking bad sectors: `-f`
  * Eject pendrive: `TODO`

### Wifi configuration
* Using `nmtui` or `nmcli`.
* EDUROAM:
  `nmcli con add type wifi ifname wlo1 con-name eduroam ssid eduroam --`
  `wifi-sec.key-mgmt wpa-eap 802-1x.eap ttls 802-1x.phase2-auth pap 802-1x.identity <...>`
  * CA validation: `802-1x.ca-cert <path>`
  * Anonymous: `802-1x.anonymous-identity`
  * Client certificate: `client-cert`, `private-key`, `private-key-password`?
  * For corporate networks: `pap` -> `mschapv2`
* To show: `nmcli con show`
* To delete if mistaken: `nmcli con delete <CN>`
* `nmcli --ask con up <CN>`
  * Provide username and password.
  * Or use password file, or pass as arguments.
* Or manually edit the connection file.
