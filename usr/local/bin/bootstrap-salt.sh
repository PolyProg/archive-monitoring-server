#!/usr/bin/env sh

set -eux

if [[ $EUID -ne 0 ]]; then
    echo "You must run this script as root" >&2
    exit 1
fi

dnf install -y salt-master salt-minion


systemctl start salt-master
systemctl start salt-minion

ssh-keygen -t rsa -N "" -f /srv/salt/master/files/misc/icinga2_ssh/id_rsa

salt "*" state.highstate
