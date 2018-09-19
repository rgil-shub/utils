#!/bin/bash

# /etc/cron.daily/apt-check-update.sh
#
# Check and notify updates (apt list --upgradable)
# Requires: bsd-mailx
# Version: 20180919

USER="user@example.org"
SENDER="root@example.org"

apt-get update > /dev/null

UPDATES=$(apt list --upgradable 2>/dev/null)
NUM_UPDATES=$(echo "${UPDATES}" | grep -c '/')

if [ "${NUM_UPDATES}" -ne "0" ]; then
    echo -e "${UPDATES}" | mail -r ${SENDER} \
        -s "apt: ${NUM_UPDATES} Updates Available (on $(hostname))" ${USER}
fi
