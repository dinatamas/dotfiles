#!/usr/bin/env bash
#
# Start screen recording.
# All arguments are passed to wf-recorder.
#

pid=`pgrep wf-recorder`
status=$?
if [ $status != 0 ]; then
  # Start recording if not already running.
  wf-recorder -a -f "$HOME/.local/recordings/$(date '+%Y-%m-%d_%H-%M-%S').mp4" "${@}"
else
  # Stop currently running recording.
  pkill --signal SIGINT wf-recorder
fi
