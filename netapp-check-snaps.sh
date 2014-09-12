#!/bin/bash

# Description: Check if all netapp volumes have recent snapshots
# Requires: ssh (openssh-clients) 
# Version 20140912

USER="root"
FILER="$1"
TODAY="$(date +%b" "%d)"

# Volumes not monitored
# EXCEPTION="OLD_*|FC_*|TEST*"
EXCEPTION="OLD_*|vol_SAN0|vol_SAN1|FC_*|CommServe07|SAP_INT|SAP_PRO|SAP_DES|esx0*|vdi0*"

# NetApp english dates
export LANG="en_EN.utf8"

usage() {
cat << EOF
NetApp Snapshots status
Usage: $0 [filer]
EOF
exit 1
}

# args
if [ $# != "1" ] ; then
    usage
fi

# ssh?
if [ ! -f /usr/bin/ssh ] ; then
    echo "ssh command not found, please install openssh-clients."
    exit 1
fi

# host up?
ping -q -w 1 "${FILER}" > /dev/null
if [ $? -ne 0 ] ; then
    echo "Host ${FILER} down !"
    exit 1
fi

# Number of online volumes
NUM_VOLS=$(ssh ${USER}@"${FILER}" vol status \
    | grep -vP "${EXCEPTION}" | grep -c "online")
echo "> Volumes: ${NUM_VOLS}"

# Today's nightly.0 or weekly.0 snapshots
NUM_SNAPS=$(ssh ${USER}@"${FILER}" snap list \
    | grep -i "${TODAY}" | grep -cP "nightly.0|weekly.0")
echo "> Snapshots: ${NUM_SNAPS} (${TODAY})"

# Volumes without recent snapshots
if [ "${NUM_VOLS}" -eq "${NUM_SNAPS}" ]; then
    echo "* All volumes with recent snapshots"
    exit 0
else
    echo "* There are volumes without recent snapshots !"
    VOLUMES=$(ssh ${USER}@"${FILER}" vol status \
        | grep -vP "${EXCEPTION}" \
        | grep "online" \
        | awk '{ print $1}')
    for VOLUME in ${VOLUMES};
    do
        ssh ${USER}@"${FILER}" snap list ${VOLUME} \
            | grep -i "${TODAY}" \
            | grep -P "nightly.0|weekly.0" > /dev/null
        if [ $? = "0" ] ; then
            echo "[OK] ${VOLUME}"
        else
            echo "[!!] ${VOLUME}"
        fi
    done
    exit 1
fi
