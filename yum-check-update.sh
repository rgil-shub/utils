#!/bin/bash

# Check and notify updates (yum check-update)

USER="user@example.org"
SERVER="server.example.org"

UPDATES=$(yum check-update -q)

if [ "$?" -eq "100" ]; then
    NUM_UPDATES=$(echo "$UPDATES" | grep -v ^$ | wc -l)
    echo "$UPDATES" | \
    mail -s "yum: "$NUM_UPDATES" Updates Available (on $SERVER)" $USER
fi
