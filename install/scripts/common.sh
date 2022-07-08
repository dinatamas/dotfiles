#!/usr/bin/env bash
#
# Some useful functionality common for many bash scripts.
# This script is only meant to be included, not executed!
#
# Usage: `source /opt/dinatamas/common.inc.sh || exit 1`
#
# Interface:
#   - Define _dt_cleanup to perform custom cleanup before exit.
#   - The workdir of the script will be the script's directory.
#   - Use _dt_set_debug .. _dt_set_critical to set the log level.
#   - Use _dt_debug ... _dt_critical for logging.
#   - Some utility functions that are always useful.
#
# Sources:
#   * https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#   * https://kvz.io/bash-best-practices.html
#   * https://stackoverflow.com/a/27701642
#   * https://medium.com/@dirk.avery/the-bash-trap-trap-ce6083f36700
#   * https://stackoverflow.com/q/48086633
#   * https://betterdev.blog/minimal-safe-bash-script-template/
#   * https://www.nicksantamaria.net/post/boilerplate-bash-script/
#   * https://intoli.com/blog/exit-on-errors-in-bash-scripts/
#   * https://www.conjur.org/blog/improving-logs-in-bash-scripts/
#
set -Eeuo pipefail
set -o history -o histexpand  # Enable !! command completion.

trap '__dt_catch $? $LINENO' EXIT

_dt_logdir='/var/log/dinatamas'
_dt_logfile="${_dt_logdir}/$(basename "$0")_$(date +'%Y_%m_%d_%H_%M_%S').log"

__dt_log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$_dt_logfile" 1>&2
}

declare -a __dt_tmpdirs=()

__dt_catch() {
    if [ "$1" != "0" ]; then
        __dt_log "Error code $1 received on line $2"
        __dt_log "Bash source stack: ${BASH_SOURCE[@]}"
    fi
    command -v _dt_cleanup 1>/dev/null 2>&1 && _dt_cleanup
    cd "${_dt_orig}"
    for tmpdir in ${__dt_tmpdirs[*]}; do
        rm -rf "${tmpdir}"
    done
}

_dt_dir="$(dirname "$(realpath -s "$0")")"
_dt_orig="$(pwd)"

cd "${_dt_dir}"

__dt_loglevel=4

_dt_set_debug()    { __dt_loglevel=5; }
_dt_set_info()     { __dt_loglevel=4; }
_dt_set_warning()  { __dt_loglevel=3; }
_dt_set_error()    { __dt_loglevel=2; }
_dt_set_critical() { __dt_loglevel=1; }

_dt_debug()    { [ ${__dt_loglevel} -gt 4 ] && __dt_log '[DT-DEBUG]    ' $*; }
_dt_info()     { [ ${__dt_loglevel} -gt 3 ] && __dt_log '[DT-INFO]     ' $*; }
_dt_warning()  { [ ${__dt_loglevel} -gt 2 ] && __dt_log '[DT-WARNING]  ' $*; }
_dt_error()    { [ ${__dt_loglevel} -gt 1 ] && __dt_log '[DT-ERROR]    ' $*; }
_dt_critical() { [ ${__dt_loglevel} -gt 0 ] && __dt_log '[DT_CRITICAL] ' $*; }

#
# Utility functions
#

_dt_ask_proceed () {
    read -s -p 'Press Enter to proceed, Ctrl+C to abort...' _
    # This will clear the previously printed prompt line.
    echo -en '\033[2K'; printf '\r'
}

_dt_strip_comments() {
    echo "${*}" | sed 's:[ \t]*#.*$::g'
}

_dt_ensure_root() {
    if [ "${EUID}" -ne 0 ]; then
        _dt_critical 'Please run this script as root'
        exit 1
    fi
}

_dt_tmpdir() {
    mkdir -p -m 1777 '/tmp/dinatamas/'
    tmpdir=$(mktemp -d -p '/tmp/dinatamas/' "$(basename "$0")_XXXXXX")
    _dt_info "Using temporary directory: ${tmpdir}"
    __dt_tmpdirs+=("${tmpdir}")
    echo "${tmpdir}"
}
