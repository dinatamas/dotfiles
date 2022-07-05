#!/usr/bin/env fish
#
# Configuration for the Friendly Interactive SHell (fish).
#

# Disable greeting.
set fish_greeting ""

# Sane defaults and better alternatives.
alias cp        "rsync -ah"
alias dd        "dd status=progress"
alias df        "df -ha"
alias diff      "diff --color=auto"
alias du        "du -h --max-depth=1"
alias feh       "feh --scale-down --draw-filename --auto-rotate --auto-reload"
alias grep      "grep --color=auto -nI --exclude-dir=.git"
alias mkdir     "mkdir -p"
alias rm        "rm -i"
alias ping      "ping -c 3"
alias python    "ipython"
alias shutdown  "shutdown now"
alias sway      "sway --unsupported-gpu"
alias tmux      "tmux -u"
alias vim       "nvim"
alias xelatex   "xelatex -halt-on-error"

# Move dotfiles away from home.
alias code      "code --extensions-dir ~/.config/vscode"
alias svn       "svn --config-dir ~/.config/subversion"
alias wget      "wget --hsts-file ~/.cache/wget-hsts"

# Use cd and ls together.
function cd; builtin cd $argv && ls; end

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

# Move dotfiles away from home.
# https://wiki.archlinux.org/title/XDG_Base_Directory
set -xg CUDA_CACHE_PATH      "$HOME/.cache/nv"
set -xg DOCKER_CONFIG        "$HOME/.config/docker"
set -xg EMACS_USER_DIRECTORY "$HOME/.config/emacs.d"
set -xg GIT_CONFIG           "$HOME/.config/git/config"
set -xg GNUPGHOME            "$HOME/.local/gnupg"
set -xg GRIM_DEFAULT_DIR     "$HOME/.local/screenshots"
set -xg HISTFILE             "$HOME/.local/bash_history"
set -xg IPYTHONDIR           "$HOME/.config/ipython"
set -xg _JAVA_OPTIONS        "-Djava.util.prefs.userRoot=$HOME/.config/java"
set -xg LESSHISTFILE         "$HOME/.config/lesshst"
set -xg NUGET_PACKAGES       "$HOME/.cache/NuGetPackages"
set -xg PYLINTHOME           "$HOME/.cache/pylint"
set -xg WINEPREFIX           "$HOME/.local/share/wineprefixes/default"

# Configure paths.
set -xg GOPATH               "/opt/go/"
set -xg PATH                 "/opt/dinatamas/" "$HOME/.local/bin" $PATH
set -xg PYTHONPATH           "./" "/opt/repo/" $PYTHONPATH

# Application-specific env vars.
set -xg DOCKER_BUILDKIT 1
set -xg MOZ_ENABLE_WAYLAND 1
set -xg PYTHONDONTWRITEBYTECODE 1
set -xg QT_QPA_PLATFORM "wayland"

# Default program variables.
set -xg BROWSER "firefox"
set -xg EDITOR  "nvim"
set -xg PAGER   "less"
set -xg VISUAL  "nvim"

# Long prompts are not good.
set -g fish_prompt_pwd_dir_length 3

# Avoid advanced config for stupid shells.
if not [ "$TERM" = "linux" ]

    # Cool but simple shell prompt.
    function fish_prompt
        set stat $status
        printf '\n╭──(%s%s%s) ○ [%s%s%s] - %s(%s)%s\n╰─%sλ%s ' \
            (set_color blue) $USER (set_color normal) \
            (set_color blue) (prompt_pwd) (set_color normal) \
            (set_color \
                (if test $stat -eq 0; echo green; else; echo red; end)) \
            $stat (set_color normal) \
            (set_color blue) (set_color normal)

        # Stupid systems: Simplified characters and no colors.
        # printf '\n┌─(%s ○ %s) - [%s] - (%s)\n└─$ ' \
        #     $USER $hostname (prompt_pwd) $stat
    end

end

# Local configuration overwrites.
set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end

# Start the graphical interface at first login.
if [ (tty) = "/dev/tty1" ]
    sway
end
