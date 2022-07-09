#
# https://github.com/IlanCosman/tide/wiki/Configuration
# ~/.config/fish/functions/tide/configure/configs/*.fish
# Call `tide configure` with 311112222121 for first time setup.
#

# Gruvbox color scheme.
set bg0 282828
set bg1 3c3836
set bg2 504945
set fg0 fbf1c7
set fg1 ebdbb2
set fg2 d5c4a1

set -g tide_prompt_color_frame_and_connection $fg1
set -g tide_prompt_color_separator_same_color $fg0

set -e tide_left_prompt_items

set -g tide_left_prompt_items $tide_left_prompt_items pwd
set -g tide_pwd_bg_color blue
set -g tide_pwd_color_anchors $fg0
set -g tide_pwd_color_dirs $fg0
set -g tide_pwd_color_truncated_dirs $fg0
set -g tide_pwd_icon_home 

set -g tide_left_prompt_items $tide_left_prompt_items git
set -g tide_git_bg_color green
set -g tide_git_bg_color_unstable bryellow
set -g tide_git_bg_color_urgent red
set -g tide_git_color_branch $bg0
set -g tide_git_color_conflicted $bg0
set -g tide_git_color_dirty $bg0
set -g tide_git_color_operation $bg0
set -g tide_git_color_staged $bg0
set -g tide_git_color_stash $bg0
set -g tide_git_color_untracked $bg0
set -g tide_git_color_upstream $bg0
set -g tide_git_icon 

set -g tide_left_prompt_items $tide_left_prompt_items newline

set -e tide_right_prompt_items

set -g tide_right_prompt_items $tide_right_prompt_items status
set -g tide_status_bg_color $bg2
set -g tide_status_bg_color_failure red
set -g tide_status_color brgreen
set -g tide_status_color_failure $fg1

set -g tide_right_prompt_items $tide_right_prompt_items cmd_duration
set -g tide_cmd_duration_bg_color bryellow
set -g tide_cmd_duration_color $bg0

set -g tide_right_prompt_items $tide_right_prompt_items context
set -g tide_context_bg_color $bg1
set -g tide_context_color_default brcyan
set -g tide_context_color_root brred
set -g tide_context_color_ssh brcyan

set -g tide_right_prompt_items $tide_right_prompt_items jobs
set -g tide_jobs_bg_color brgreen
set -g tide_jobs_color $bg1

set -g tide_right_prompt_items $tide_right_prompt_items virtual_env
set -g tide_virtual_env_bg_color brcyan
set -g tide_virtual_env_color $bg0

set -g tide_right_prompt_items $tide_right_prompt_items docker
set -g tide_docker_bg_color brblue
set -g tide_docker_color $bg0
