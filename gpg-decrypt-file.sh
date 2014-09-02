#!/bin/bash

# Description: Decrypt files with GPG
# Requires: gpg (gnupg)
# Version: 20140902

# echo ${FILENAME}     -> file.txt.gpg
# echo ${FILENAME%.*}  -> file.txt
# echo ${FILENAME%%.*} -> file

FILE_IN="$1"
FILE_OUT=$(echo ${FILE_IN%.*})

OPTIONS="--output ${FILE_OUT} --decrypt ${FILE_IN}"

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
