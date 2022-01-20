#!/usr/bin/env bash
#
# secrets.sh compress:
#   - Add sensitive data to an encrypted archive `secrets.7z`.
#
# secrets.sh extract:
#   - Deploy sensitive data to a new system.
#
source /opt/repo/dotfiles/scripts/common.sh || exit 1

_dt_ensure_root

sdir='/tmp/dinatamas/secrets'
archive='/opt/repo/dotfiles/resources/secrets.7z'
mkdir -p -m 1777 '/tmp/dinatamas'

rm -rf "${sdir}"

_dt_cleanup() {
    rm -rf "${sdir}"
}

mkdir -p "${sdir}"

if [ "$1" = 'compress' ]; then

    rsync -r '/home/dinatamas/.ssh' "${sdir}/ssh"
    mkdir -p "${sdir}/wifi"
    rsync -r '/etc/NetworkManager/system-connections/*.nmconnection' "${sdir}/wifi/"

    rm -f "${archive}"
    7z -p a "${archive}" "${sdir}/*"

fi

if [ "$1" = 'extract' ]; then

    if [ ! -f "${archive}" ]; then
        _dt_critical 'No secrets.7z archive, exiting'
        exit 1
    fi

    7z x "${archive}" -o"${sdir}"

    mkdir -p '/home/dinatamas/.ssh'
    rsync -r "${sdir}/ssh/*" '/home/dinatamas/.ssh'
    chown -R dinatamas:dinatamas '/home/dinatamas/.ssh'
    chmod 700 '/home/dinatamas/.ssh'
    chmod 644 '/home/dinatamas/.ssh/authorized_keys' || true
    chmod 644 '/home/dinatamas/.ssh/known_hosts'
    chmod 644 '/home/dinatamas/.ssh/config' || true
    chmod 600 '/home/dinatamas/.ssh/id_ed25519'
    chmod 644 '/home/dinatamas/.ssh/id_ed25519.pub'

    rsync -r "${sdir}/wifi/*" '/etc/NetworkManager/system-connections/'
    chown -R root:root '/etc/NetworkManager/system-connections/'
    chmod 600 '/etc/NetworkManager/system-connections/*'

fi
