#!/bin/bash

# Check netapp volume space
# Requires: awk (gawk) ssh (openssh-clients) 
# Version 20140827

USER="root"
FILER="$1"

HIGH_PERCENTAGE="80"
LOW_PERCENTAGE="10"

TXT_RED='\e[0;31m'
TXT_GREEN='\e[0;32m'
TXT_RST='\e[0m'

usage() {
cat << EOF
NetApp volume status
Usage: $0 [filer]
EOF
exit 1
}

if [ $# != "1" ] ; then
    usage
fi

if [ ! -f /usr/bin/awk ] ; then
    echo "awk command not found, please install gawk."
    exit 1
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

ssh ${USER}@${FILER} df -h | grep -v -P ".snapshot|Filesystem" | sort \
    | while read line
do

    PERCENTAGE=$(echo ${line} | awk '{ print $5 }' | cut -d "%" -f1 )
    OUTPUT=$(echo ${line} | awk '{ print $1 "\t" $5 }')
    
    if [ ${PERCENTAGE} -gt ${HIGH_PERCENTAGE} ] ; then
        echo -e ${TXT_RED}${OUTPUT}${TXT_RST}
    elif [ ${PERCENTAGE} -lt ${LOW_PERCENTAGE} ] ; then
        echo -e ${TXT_GREEN}${OUTPUT}${TXT_RST}
    else
        echo ${OUTPUT}
    fi

done
