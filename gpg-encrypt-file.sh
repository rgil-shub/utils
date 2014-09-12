#!/bin/bash

# Description: Encrypt files with GPG symmetric and AES256 cipher 
# Requires: gpg (gnupg)
# Version: 20140912

FILE_IN="$1"
FILE_OUT="$1".gpg

CIPHER="AES256"
COMPRESS="zlib"

OPTIONS="--output ${FILE_OUT} \
    --cipher-algo ${CIPHER} \
    --compress-algo ${COMPRESS} \
    --symmetric ${FILE_IN}"

usage() {
cat << EOF
Usage: $0 [file]
EOF
exit 1
}

# args
if [ $# != "1" ] ; then
    usage
fi

# gpg?
if [ ! -f /usr/bin/gpg ] ; then
    echo "gpg command not found, please install gnupg."
    exit 1
fi

gpg ${OPTIONS}
