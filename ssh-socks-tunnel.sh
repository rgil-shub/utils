#!/bin/bash

# SSH encrypted SOCKS tunnel
# https://wiki.archlinux.org/index.php/Secure_Shell#Encrypted_SOCKS_tunnel
# Requires: ssh (openssh-clients)
# Version: 20150209

PORT_SERVER="22"
PORT_CLIENT="8080"
USER="example_user"
SERVER="example_server"

if [ ! ${EUID} == 0 ] ; then
    echo "Root privileges are required."
    exit 1
fi

if [ ! -f /usr/bin/ssh ] ; then
    echo "ssh command not found, please install openssh-clients."
    exit 1
fi

ssh -v -p ${PORT_SERVER} -TND ${PORT_CLIENT} ${USER}@${SERVER}
