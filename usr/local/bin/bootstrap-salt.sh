#!/usr/bin/env sh

set -eux

if [[ $EUID -ne 0 ]]; then
    echo "You must run this script as root" >&2
    exit 1
fi

curl -L https://bootstrap.saltstack.com -o /tmp/salt.sh
sh /tmp/salt.sh -P -M
rm /tmp/salt.sh

systemctl start salt-master
systemctl start salt-minion
