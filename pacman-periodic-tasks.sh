#!/bin/bash

# Description: Pacman periodic tasks
# Version: 20180731

# TASK 1: Update package file list:
# # pacman -S pkgfile
# # pkgfile --update
# $ source /usr/share/doc/pkgfile/command-not-found.bash  # BASH
# $ source /usr/share/doc/pkgfile/command-not-found.zsh   # ZSH

#
# $ bc
# bc may be found in the following packages:
#   extra/bc 1.06.95-1                /usr/bin/bc
#   community/9base 6-5               /opt/plan9/bin/bc
#   community/plan9port 20140306-1    /usr/lib/plan9/bin/bc

# TASK 2: Show and remove packages not in official repositories
# $ pacman -Qm
# # pacman -Rsn "$(pacman -Qm | cut -d " " -f1)"

# TASK 3: Show and remove unused apps: 
# $ pacman -Qdtq
# $ pacman -Qdttq   # Include packages optionally required by another package
# # pacman -Rsn "$(pacman -Qdtq)"

# TASK 4: 
# > Deletes all the cached versions of each package except for 
#   the most recent 3:
# # paccache -r
# > Removing all the cached versions of uninstalled packages
# # paccache -ruk0
# > Optional: Remove all the cached packages not currently installed
# # pacman -Sc

# root?
if [ ! ${EUID} == 0 ]; then
    echo "Root privileges are required for running pacman tasks !"
    exit 1
fi

# task 1
echo "* Updating package file list..."
pkgfile --update

# task 2
echo "* Obsolete apps..."
# pacman -Rsn "$(pacman -Qm | cut -d " " -f1)"
pacman -Qm | cut -d " " -f1

# task 3
echo "* Unused apps..."
# pacman -Rsn "$(pacman -Qdttq)"
pacman -Qdttq

# task 4
echo "* Removing cached packages (except most recent 3)..."
paccache -r
echo "* Removing all the cached versions of uninstalled packages..."
paccache -ruk0
