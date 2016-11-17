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

readonly PASSWD=/srv/salt/pillars/passwords.sls

if [ ! -f ${PASSWD} ]; then
	echo "Please enter icinga web password"
	read password

	ICINGA2_DB=`openssl rand -base64 32`
	ICINGAWEB2_DB=`openssl rand -base64 32`

	echo "icinga2_db_password: ${ICINGA2_DB}" > ${PASSWD}
	echo "icingaweb2_db_password: ${ICINGAWEB2_DB}" >> ${PASSWD}
	echo "" >> ${PASSWD}
	echo "icingaweb2_password: ${password}" >> ${PASSWD}
fi

if [ ! -f /srv/salt/master/files/misc/icinga2/ssh/id_rsa ]; then
	ssh-keygen -t rsa -N "" -f /srv/salt/monitor/files/misc/icinga2/ssh/id_rsa
fi

salt "*" state.highstate
