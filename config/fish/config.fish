#!/usr/bin/env fish
# Disable greeting.
set fish_greeting ""

# Set miscellaneous aliases.
alias diff      "diff --color=auto"
alias feh       "feh --scale-down --draw-filename --auto-rotate --auto-reload"
alias fgrep     "fgrep --color=auto"
alias mkdir     "mkdir -p"
# TODO: Configure rm to use a trash (if small/not on pendrive).
# TODO: Auto-manage/clean that trash.
alias rm        "rm -i"
alias ping      "ping -c 2"
alias shutdown  "shutdown now"
alias startgui  "sway --my-next-gpu-wont-be-nvidia"
alias wget      "wget --hsts-file ~/.cache/wget-hsts"
alias xelatex   "xelatex -halt-on-error"
# TODO: copy, dd, some other commands always show progress (tqdm?)!

# Print everything, just not the home directory.
# TODO: Make this a bit less redundant!
functions --copy "ls" "ls_original"
function ls --wraps='ls_original'
    set ls_args "-hFC" "--color=auto"
    if test (count $argv) -eq 0 -a $PWD = ~
        ls_original $ls_args $argv
    else if test (count $argv) -eq 1
        if test -d $argv[1]
            if test (realpath $argv[1]) = ~
                ls_original $ls_args $argv
            else
                ls_original -A $ls_args $argv
            end
        else
            ls_original -A $ls_args $argv
        end
    else
        ls_original -A $ls_args $argv
    end
end

# Make C++ behave like a normal person.
# Fore more: https://stackoverflow.com/a/12247461
# Also set stack size? Also more safety related options?
# alias g++ "g++ -std=c++17 -O3 -Wall -Wextra -Wfloat-equal -Wundef -Wcast-align -Wwrite-strings -Wlogical-op -Wmissing-declarations -Wredundant-decls -Wshadow -Woverloaded-virtual"

# Special escape characters for the terminal.
# https://medium.com/@joao.paulo.silvasouza/change-your-terminals-background-color-dynamically-using-escape-sequences-aba6e5ed2b29
# https://chrisyeh96.github.io/2020/03/28/terminal-colors.html
set DARK "#282828"
set LIGHT "#fbf1c7"
set RED "#cc241d"
set GRAY "#928374"
set FG1 "#3c3836"

function set_term_bg
    printf "\\033]11;$argv[1]\\007"
end

function set_term_cursor_color
    printf "\\033]12;$argv[1]\\007"
end

function reset_term_cursor_color
    printf "\\033]112\\007"
end

# Do not open directories with emacs.
function emacs --wraps='emacs'
    set newargs
    for a in $argv
        if not test -d $a
            set -a newargs $a
        end
    end
    set oldcount (count $argv)
    set newcount (count $newargs)
    #set_term_bg $BLACK_BG
    if test $newcount -ne 0
        /usr/bin/emacs -nw $newargs
    else if test $oldcount -eq 0
        /usr/bin/emacs -nw -f "direx:jump-to-directory"
    end
    #set_term_bg $DEFAULT_BG
end

function vim --wraps='nvim'
    set_term_bg $LIGHT
    set_term_cursor_color $GRAY
    /usr/bin/nvim $argv
    reset_term_cursor_color
    set_term_bg $DARK
end

# Jokes on you, nvim is the actually improved editor.
function vi --wraps='vim'
    set_term_bg $LIGHT
    set_term_cursor_color $GRAY
    /usr/bin/vim -u ~/.config/vim/vimrc $argv
    reset_term_cursor_color
    set_term_bg $DARK
end

function colortest
    # https://askubuntu.com/a/821163
    /bin/bash -c '
    for i in {0..255} ; do
    printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i"
    if (( i == 15 )) || (( i > 15 )) && (( (i-15) % 6 == 0 )); then
        printf "\n";
    fi
    done'
end

# Exclude files and directories for grep.
# TODO: egrep, fgrep?
while read line
    if string match -r -q '#.*' $line
        continue
    else if string match -r -q '^$' $line
        continue
    end
    set EXCLUDE_DIR $EXCLUDE_DIR --exclude-dir=$line
end < ~/.config/grep/grepignore-dir
# TODO: Break this line into shorter lines
alias grep "grep --color=auto -nIT $EXCLUDE_DIR --exclude-from=/home/dinatamas/Downloads/dotfiles/fs/home/skel/dot_config/grep/grepignore"

# Mute the less pager.
set -x LESS "$LESS -R -Q"

# Add color to less and man.
set -x LESS_TERMCAP_mb (printf "\033[01;31m")
set -x LESS_TERMCAP_md (printf "\033[01;31m")
set -x LESS_TERMCAP_me (printf "\033[0m")
set -x LESS_TERMCAP_se (printf "\033[0m")
set -x LESS_TERMCAP_so (printf "\033[01;44;33m")
set -x LESS_TERMCAP_ue (printf "\033[0m")
set -x LESS_TERMCAP_us (printf "\033[01;32m")

# Don't print directory background colors.
set -Ux LS_COLORS $LS_COLORS:'tw=00;33:ow=01;33:'

# Use cd and ls together.
function cd
    builtin cd $argv; and ls
end

# Change some global config paths.
set -x GIT_CONFIG "~/.config/git/config"

# Change some user-specific config paths.
# TODO: .atom, .audacity-data, .cups, .java, .ghidra
# TODO: .dotnet, .mozilla, .gnupg, .nuget, .pki, .pylint.d
# TODO: .steam*, .templateengine, .vscode-oss, .wine
# TODO: Remove/disable .wget_hsts, .sudo_as_admin_successful
# TODO: ~/bin? docker, rootlesskit, runc, containerd
# TODO: etc...
set -x DOCKER_CONFIG "$HOME/.config/docker"
set -x EMACS_USER_DIRECTORY "$HOME/.config/emacs.d"
set -x GNUPGHOME "$HOME/.local/gnupg"
set -x LESSHISTFILE "$HOME/.config/lesshst"
set -x PYTHONSTARTUP "$HOME/.config/python/pythonrc.py"
set -x PYTHONPATH "." "/opt/repo" $PYTHONPATH

# Some application-specific env vars.
set -xg MOZ_ENABLE_WAYLAND 1
set -xg PYTHONDONTWRITEBYTECODE 1
set -xg GOPATH "/opt/go"
set -xg DOCKER_BUILDKIT 1  # TODO: Needs to be installed?
# TODO: These binaries shouldn't be in the home dir!
# https://stackoverflow.com/a/21127855
# set -xg PATH $PATH "/home/dinatamas/bin"
set -xg PATH $PATH "/opt/dinatamas/"
set -xg DOCKER_HOST unix:///run/user/1000/docker.sock
# TODO: docker context use rootless
# global --context flag?
# https://docs.docker.com/engine/security/rootless/
# https://wiki.archlinux.org/title/Docker#Docker_rootless

# Default program variables.
set -xg BROWSER "firefox"
set -xg EDITOR "emacs"
set -xg PAGER "less"
set -xg VISUAL "emacs"

# Utilities.
alias battery "cat /sys/class/power_supply/BAT0/capacity"

# Proper sway and flameshot setup.
# TODO: Still need to fix up a few things.
# https://github.com/flameshot-org/flameshot/blob/master/docs/Sway%20and%20wlroots%20support.md
set -xg SDL_VIDEODRIVER wayland
set -xg _JAVA_AWT_WM_NONREPARENTING 1
set -xg QT_QPA_PLATFORM wayland
set -xg XDG_CURRENT_DESKTOP sway
set -xg XDG_SESSION_DESKTOP sway

# Long prompts are not good.
set fish_prompt_pwd_dir_length 3

# Avoid advanced config for stupid shells.
if not [ "$TERM" = "linux" ]

    # Cool but simple shell prompt.
    function fish_prompt
        set stat $status
        printf '\n╭──(%s%s%s ○ %s%s%s) - [%s%s%s] - %s(%s)%s\n╰─%sλ%s ' \
            (set_color blue) $USER (set_color normal) \
            (set_color blue) $hostname (set_color normal) \
            (set_color blue) (prompt_pwd) (set_color normal) \
            (set_color \
                (if test $stat -eq 0; echo green; else; echo red; end)) \
            $stat (set_color normal) \
            (set_color blue) (set_color normal)
    end

else

    # TODO: Consider using a greeter (lightdm) instead?
    if [ (tty) = "/dev/tty1" ]
         startgui
    end

end
