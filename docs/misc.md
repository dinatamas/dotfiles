# Miscellaneous docs

To generate a list of installed packages:
`pacman -Qe | awk '{print $1}' > packages.txt`

Help
====

A help page about getting help.

## Cheatsheets

Useful:
  * zathura: defkeys.com/zathura-shortcuts
  * git cheatsheets
  * gnu emacs cheatsheet (personalized!)
  * Work computer: linux cheatsheet.
  * Bash / Fish shell scripting.
  * rofi-like quick browse / help
  * other help functionality: info, man, ...

Direx cheatsheet:
  * R - rename
  * C - copy
  * D - delete
  * + - mkdir
  * M - chmod
  * L - load
  * G - chgrp
  * O - chown
  * T - touch
  * e - long ls form
  * E - expand recursively
  * ^ - up item
  * g - refresh
  * F - new file
  * f - result of `file` command

## Troubleshooting

* Other TTYs can be opened up with `Ctrl+Alt+F<n>`
* Hold `Shift` to open GRUB menu during bootup.

Bash scripting guide
====================

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

## Background tasks
* `&`, `nohup`, `disown`, `jobs`

## Colorscheme

Whenever possible, the Gruvbox Dark Medium colorscheme is in use.

Sources:
* https://github.com/morhetz/gruvbox
* https://github.com/dawikur/base16-gruvbox-scheme
* https://gist.github.com/kamek-pf/2eae4f570061a97788a8a9ca4c893797
* https://github.com/greduan/emacs-theme-gruvbox
* https://github.com/eendroroy/alacritty-theme
* https://github.com/aarowill/base16-alacritty
* https://addons.mozilla.org/de/firefox/addon/gruvbox-dark/
  * Or: Dark Reader extension with Sepia
* https://github.com/alacritty/alacritty/wiki/Color-schemes
* https://github.com/bardisty/gruvbox-rofi
* Terminator has builtin support for Gruvbox.

| #282828 | ----      |
| #3c3836 | ---       |
| #504945 | --        |
| #665c54 | -         |
| #bdae93 | +         |
| #d5c4a1 | ++        |
| #ebdbb2 | +++       |
| #fbf1c7 | ++++      |
| #fb4934 | red       |
| #fe8019 | orange    |
| #fabd2f | yellow    |
| #b8bb26 | green     |
| #8ec07c | aqua/cyan |
| #83a598 | blue      |
| #d3869b | purple    |
| #d65d0e | brown     |
