#!/bin/bash

# /etc/cron.daily/yum-check-update.sh
#
# Check and notify updates (yum check-update)
# Requires: mailx
# Version: 20140911

USER="user@example.org"
SENDER="root@example.org"

UPDATES=$(yum check-update -q)

if [ "$?" -eq "100" ]; then

    NUM_UPDATES=$(echo "${UPDATES}" | grep -v ^$ | wc -l)

    ### RHEL5 ###
    # echo "${UPDATES}" | mail \
    #    -s "yum: ${NUM_UPDATES} Updates Available (on $(hostname))" ${USER} \
    #    -- -f ${SENDER}

    ### RHEL6+ ###
    echo "${UPDATES}" | mail -r ${SENDER} \
        -s "yum: ${NUM_UPDATES} Updates Available (on $(hostname))" ${USER}
fi
