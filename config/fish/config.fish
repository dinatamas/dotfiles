#!/usr/bin/env fish
#
# Configuration for the Friendly Interactive SHell (fish).
#

# Use bash in debug terminals.
if string match -r '/dev/tty[2-9]' (tty) > /dev/null
  bash
  exit
end

if ! string match '/dev/tty*' (tty) > /dev/null
  # Start tmux when not already in it.
  # The fish shell inside tmux will initialize itself.
  if status --is-interactive
   and not set -q TMUX
    exec tmux -u a || tmux -u
    exit
  end
end

# Set tmux option to destroy the session,
# when it was starting in alacritty.
if test $TMUX_AUTOKILL
  tmux set-option destroy-unattached on
end

# Disable greeting.
set fish_greeting ""

# Configure paths.
set -xg GOPATH     "/opt/go"
set -xg PATH       "$HOME/.local/bin" "$GOPATH/bin" $PATH
set -xg PYTHONPATH "./" "/opt/repo/" $PYTHONPATH

# Sane defaults and better alternatives.
alias cat       "bat -p"
alias cp        "rsync -ah"
alias dd        "dd status=progress"
alias df        "df -ha"
alias diff      "diff --color=auto"
alias du        "du -h --max-depth=1"
alias feh       "feh --scale-down --draw-filename --auto-rotate --auto-reload"
alias grep      "grep --color=auto -nI --exclude-dir=.git"
alias less      "bat"
alias ll        "exa -alg --icons --git"
alias ls        "exa -a"
alias mkdir     "mkdir -p"
alias mv        "mv -i"
alias rm        "rm -i"
alias ping      "ping -c 3"
alias python    "ipython"
alias shutdown  "shutdown now"
alias sway      "sway --unsupported-gpu"
alias tmux      "tmux -u"
alias tree      "exa -a --tree --icons --level=2 --ignore-glob='.git'"
alias vim       "nvim"
alias xelatex   "xelatex -halt-on-error"

# Move dotfiles away from home.
alias code      "code --extensions-dir ~/.config/vscode"
alias svn       "svn --config-dir ~/.config/subversion"
alias wget      "wget --hsts-file ~/.cache/wget-hsts"

# Use cd and ls together.
function cd; builtin cd $argv && ls; end

# Move dotfiles away from home.
# https://wiki.archlinux.org/title/XDG_Base_Directory
set -xg CUDA_CACHE_PATH      "$HOME/.cache/nv"
set -xg DOCKER_CONFIG        "$HOME/.config/docker"
set -xg EMACS_USER_DIRECTORY "$HOME/.config/emacs.d"
set -xg GHQ_ROOT             "/opt/repo/"
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

# Application-specific env vars.
set -xg DOCKER_BUILDKIT 1
set -xg MOZ_ENABLE_WAYLAND 1
set -xg PYTHONDONTWRITEBYTECODE 1
set -xg QT_QPA_PLATFORM "wayland"

# Use bat as a man colorizing pager.
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Default program variables.
set -xg BROWSER "firefox"
set -xg EDITOR  "nvim"
set -xg PAGER   "less"
set -xg VISUAL  "nvim"

# Prompt config (managed by tide).
source ~/.config/fish/conf.d/gruvbox.fish
theme_gruvbox dark medium
source ~/.config/fish/conf.d/tide.fish

# Start the graphical interface at first login.
if test (tty) = "/dev/tty1"
  sway
end
