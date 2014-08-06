#!/bin/bash

# SSH encrypted SOCKS tunnel
# https://wiki.archlinux.org/index.php/Secure_Shell#Encrypted_SOCKS_tunnel

PORT="example_port"
USER="example_user"
SERVER="example_server"

ssh -v -TND $PORT $USER@$SERVER
