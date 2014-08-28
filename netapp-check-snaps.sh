#!/bin/bash

# Check if all netapp volumes have recent snapshots
# Requires: ssh (openssh-clients) 
# Version 20140828

USER="root"
FILER="$1"
TODAY="$(date +%b" "%d)"

# Volumes not monitored
EXCEPCION="OLD_*|FC_*|TEST*"

# NetApp english dates
export LANG="en_EN.utf8"

usage() {
cat << EOF
NetApp Snapshots status
Usage: $0 [filer]
EOF
exit 1
}

if [ $# != "1" ] ; then
    usage
fi

if [ ! -f /usr/bin/ssh ] ; then
    echo "ssh command not found, please install openssh-clients."
    exit 1
fi

ping -q -w 1 ${FILER} > /dev/null
if [ $? -ne 0 ] ; then
    echo "Host ${FILER} down !"
    exit 1
fi

# Number of online volumes
NUM_VOLS=$(ssh ${USER}@${FILER} vol status \
    | grep -vP ${EXCEPCION} |  grep -c "online")

# Today's nightly.0 or weekly.0 snapshots
NUM_SNAPS=$(ssh ${USER}@${FILER} snap list \
    | grep -i "${TODAY}" | grep -cP "nightly.0|weekly.0")

echo "> Volumes: ${NUM_VOLS}"
echo "> Snapshots: ${NUM_SNAPS} (${TODAY})"

if [ ${NUM_VOLS} -eq ${NUM_SNAPS} ]; then
    echo "* All volumes with recent snapshots"
    exit 0
else
    echo "* There are volumes without recent snapshots !"
    exit 1
fi
