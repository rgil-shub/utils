#!/bin/bash

# Check and notify updates (yum check-update)
# Requires: mailx
# Version: 20140806

DEST="user@example.org"
SENDER="root@example.org"
SERVER="server.example.org"

UPDATES=$(yum check-update -q)

if [ "$?" -eq "100" ]; then
    NUM_UPDATES=$(echo "$UPDATES" | grep -v ^$ | wc -l)
    echo "$UPDATES" | \
    mail -r $SENDER \
    -s "yum: "$NUM_UPDATES" Updates Available (on $SERVER)" $DEST
fi
