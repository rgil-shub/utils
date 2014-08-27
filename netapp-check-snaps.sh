#!/bin/bash

# Check if all netapp volumes have recent snapshots
# Requires: ssh (openssh-clients) 
# Version 20140827

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
}

if [ $# != "1" ] ; then
    usage
    exit 0
fi

if [ ! -f /usr/bin/ssh ] ; then
    echo "ssh command not found, please install openssh-clients."
    exit 1
fi

ping -q -w 1 $1 > /dev/null
if [ $? -ne 0 ] ; then
    echo "Host $1 down !"
    exit 1
fi

# Number of online volumes
NUM_VOLS=$(ssh $USER@$FILER vol status \
    | grep -vP $EXCEPCION |  grep -c "online")

# Today's nightly.0 or weekly.0 snapshots
NUM_SNAPS=$(ssh $USER@$FILER snap list \
    | grep -i "$TODAY" | grep -cP "nightly.0|weekly.0")

echo "> Volumes: $NUM_VOLS"
echo "> Snapshots: $NUM_SNAPS ($TODAY)"

if [ $NUM_VOL -eq $N_SNAPS ]; then
    echo "* All volumes with recent snapshots"
else
    echo "* There are volumes without recent snapshots !"
fi
