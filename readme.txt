Dotfiles
========

> My minimalist dotfiles.

Preferred environment
---------------------

Whenever possible I use the following tools:

 | Category    | Tool       | Configuration                |
 |-------------|------------|------------------------------|
 | os          | arch linux | `sys/etc/`                   |
 | shell       | fish       | `con/fish/`                  |
 | multiplexer | tmux       | `con/tmux/`                  |
 | editor      | nvim       | `con/nvim/`                  |
 | colors      | gruvbox    |                              |
 | font        | nerdfonts  |                              |
 | graphics    | wayland    |                              |
 | compositor  | sway       | `con/sway/`                  |
 | menu        | wofi       | `con/wofi/`                  |
 | wallpaper   |            | `sys/usr/sha/bac/dinatamas/` |
 | terminal    | alacritty  | `con/alacritty/`             |
 | browser     | firefox    |                              |
 | pdf reader  | zathura    | `con/zathura/`               |

Directory structure
-------------------

 | Path                      | Description                          |
 |---------------------------|--------------------------------------|
 | `config/`                 | User-level configuration.            |
 | `doc/misc.md`             | Temporary collection of all docs.    |
 | `res/pacman_packages.txt` | Package list.                        |
 | `res/pierre.asc.gpg`      | The GPG key of Arch Linux images.    |
 | `res/pip_packages.txt`    | Package list.                        |
 | `res/secrets.7z`          | Password-locked SSH keys, passwords. |
 | `scr/cleanup.sh`          | System maintenance and housekeeping. |
 | `scr/common.sh`           | Sensible common bash utilities.      |
 | `scr/install.sh`          | Arch Linux installation script #1.   |
 | `scr/install_chroot.sh`   | Arch Linux installation script #2.   |
 | `scr/prepare.sh`          | Prepare an Arch Linux installer.     |
 | `scr/secrets.sh`          | Prepare secrets for a migration.     |
 | `system/`                 | System-wide configuration.           |

Inspiration
-----------

  - devaslife (Youtube):

  [1](https://www.youtube.com/watch?v=RNqDkF17ogY)
  [2](https://www.youtube.com/watch?v=FW2X1CXrU1w)
  [3](https://www.youtube.com/watch?v=KKxhf50FIPI)
  [4](https://www.youtube.com/watch?v=qKpY7t5m35k)
  [5](https://www.youtube.com/watch?v=UZBjt04y4Oo)
  [6](https://www.youtube.com/watch?v=sSOfr2MtRU8)
  [7](https://github.com/craftzdog/dotfiles-public)

