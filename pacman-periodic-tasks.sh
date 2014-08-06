#!/bin/bash

# Pacman periodic tasks

# TASK 1: Optimize pacman database: 
# # pacman-optimize

# TASK 2: Update package file list:
# # pacman -S pkgfile
# # pkgfile --update
# $ source /usr/share/doc/pkgfile/command-not-found.bash
#
# $ bc
# bc may be found in the following packages:
#   extra/bc 1.06.95-1                /usr/bin/bc
#   community/9base 6-5               /opt/plan9/bin/bc
#   community/plan9port 20140306-1    /usr/lib/plan9/bin/bc

# TASK 3: Show and remove unused apps: 
# $ pacman -Qdtq
# # pacman -Rsn $(pacman -Qdtq)

. colors.sh

# root?
if [ ! ${EUID} == 0 ]; then
    echo_error "Root privileges are required for running pacman tasks"
    exit 1
fi

echo_h2 "Optimizing pacman database..."
pacman-optimize

echo_h2 "Updating package file list..."
pkgfile --update

printf '\n'; echo_h2 "Unused apps..."
pacman -Rsn $(pacman -Qdtq)
