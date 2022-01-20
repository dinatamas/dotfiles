#!/usr/bin/env fish
#
# Configuration for the Friendly Interactive SHell (fish).
#

# Disable greeting.
set fish_greeting ""

# Default parameters to command line programs.
alias code      "code --extensions-dir ~/.config/vscode"
alias df        "df -ha"
alias diff      "diff --color=auto"
alias du        "du -h --max-depth=1"
alias feh       "feh --scale-down --draw-filename --auto-rotate --auto-reload"
alias grep      "grep --color=auto -nIT --exclude-dir=.git"
alias mkdir     "mkdir -p"
alias rm        "rm -i"
alias ping      "ping -c 3"
alias shutdown  "shutdown now"
alias svn       "svn --config-dir ~/.config/subversion"
alias sway      "sway --my-next-gpu-wont-be-nvidia"
alias tmux      "tmux -u"
alias wget      "wget --hsts-file ~/.cache/wget-hsts"
alias xelatex   "xelatex -halt-on-error"

# Replace programs with improved alternatives.
alias cp        "rsync -ah --info=progress2"
alias dd        "dd status=progress"
alias python    "ipython"
alias vim       "nvim"

# Utilities.
alias battery   "cat /sys/class/power_supply/BAT0/capacity"

# Use cd and ls together.
function cd
    builtin cd $argv; and ls
end

# Print everything, just not the home directory (because it is cluttered).
# https://wiki.archlinux.org/title/XDG_Base_Directory
# If all else fails, run apps as different users / change $HOME.
functions --copy "ls" "ls_original"
function ls --wraps='ls_original'
    set ls_args "-hFC" "--color=auto" "-A"
    if test (count $argv) -eq 0 -a $PWD = ~
        set -e ls_args[3]
    else if test (count $argv) -eq 1
        if test -d $argv[1]
            if test (realpath $argv[1]) = ~
                set -e ls_args[3]
            end
        end
    end
    ls_original $ls_args $argv
end

# Mute the less pager.
set -x  LESS "$LESS -R -Q"

# Add color to less and man.
set -x  LESS_TERMCAP_mb (printf "\033[01;31m")
set -x  LESS_TERMCAP_md (printf "\033[01;31m")
set -x  LESS_TERMCAP_me (printf "\033[0m")
set -x  LESS_TERMCAP_se (printf "\033[0m")
set -x  LESS_TERMCAP_so (printf "\033[01;44;33m")
set -x  LESS_TERMCAP_ue (printf "\033[0m")
set -x  LESS_TERMCAP_us (printf "\033[01;32m")

# Don't print directory background colors.
set -xg LS_COLORS            $LS_COLORS'tw=00;33:ow=01;33:'

# Change dotfile paths.
set -x  CUDA_CACHE_PATH      "~/.cache/nv"
set -x  DOCKER_CONFIG        "~/.config/docker"
set -x  EMACS_USER_DIRECTORY "~/.config/emacs.d"
set -x  GIT_CONFIG           "~/.config/git/config"
set -x  GNUPGHOME            "~/.local/gnupg"
set -x  HISTFILE             "~/.local/bash_history"
set -x  IPYTHONDIR           "~/.config/ipython"
set -x  _JAVA_OPTIONS        "-Djava.util.prefs.userRoot=~/.config/java"
set -x  LESSHISTFILE         "~/.config/lesshst"
set -x  NUGET_PACKAGES       "~/.cache/NuGetPackages"
set -x  PYLINTHOME           "~/.cache/pylint"
mkdir -p ~/.local/share/wineprefixes/default
set -x  WINEPREFIX           "~/.local/share/wineprefixes/default"

# Configure paths.
set -xg GOPATH               "/opt/go/"
set -xg PATH                 "/opt/dinatamas/" "$HOME/.local/bin" $PATH
set -x  PYTHONPATH           "./" "/opt/repo/" $PYTHONPATH

# Application-specific env vars.
set -xg MOZ_ENABLE_WAYLAND 1
set -xg PYTHONDONTWRITEBYTECODE 1
set -xg DOCKER_BUILDKIT 1

# Default program variables.
set -xg BROWSER "firefox"
set -xg EDITOR  "emacs"
set -xg PAGER   "less"
set -xg VISUAL  "emacs"

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

        # Stupid systems: Simplified characters and no colors.
        # printf '\n┌─(%s ○ %s) - [%s] - (%s)\n└─$ ' \
        #     $USER $hostname (prompt_pwd) $stat
    end

else

    if [ (tty) = "/dev/tty1" ]
         sway
    end

end
