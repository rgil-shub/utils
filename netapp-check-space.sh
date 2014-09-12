#!/bin/bash

# Check netapp volume and aggregate space
# Requires: awk (gawk) ssh (openssh-clients) tput (ncurses)
# Version 20140912

USER="root"
FILER="$1"

HIGH_PERCENTAGE="90"
LOW_PERCENTAGE="10"

TXT_RED="tput setaf 1"
TXT_GREEN="tput setaf 2"
TXT_BOLD="tput bold"
TXT_RST="tput sgr0"

usage() {
cat << EOF
NetApp volume and aggregate status
Usage: $0 [filer]
EOF
exit 1
}

# args
if [ $# != "1" ] ; then
    usage
fi

# awk?
if [ ! -f /usr/bin/awk ] ; then
    echo "awk command not found, please install gawk."
    exit 1
fi

# ssh?
if [ ! -f /usr/bin/ssh ] ; then
    echo "ssh command not found, please install openssh-clients."
    exit 1
fi

# tput?
if [ ! -f /usr/bin/tput ] ; then
    echo "tput command not found, please install ncurses."
    exit 1
fi

# host up?
ping -q -w 1 "${FILER}" > /dev/null
if [ $? -ne 0 ] ; then
    echo "Host ${FILER} down !"
    exit 1
fi

function get_space_percentage {

    ssh "$1"@"$2" "$3" | grep -v -P "$4" | sort \
            | while read line
    do
   
        PERCENTAGE=$(echo "${line}" | awk '{ print $5 }' | cut -d "%" -f1 )
        OUTPUT=$(echo "${line}" | awk '{ print $1 "\t" $5 }')

        if [ "${PERCENTAGE}" -gt "${HIGH_PERCENTAGE}" ] ; then
            $(echo "${TXT_RED}")
            $(echo "${TXT_BOLD}")
            echo "${OUTPUT}"
            $(echo "${TXT_RST}")
        elif [ "${PERCENTAGE}" -lt "${LOW_PERCENTAGE}" ] ; then
            $(echo "${TXT_GREEN}")
            echo "${OUTPUT}"
            $(echo "${TXT_RST}")
        else
            echo "${OUTPUT}"
        fi

    done

}

### Aggregates ###
echo "* Aggregates:"
CMD="df -A"
MATCH=".snapshot|Aggregate"
get_space_percentage "${USER}" "${FILER}" "${CMD}" "${MATCH}"

### Volumes ###
echo "* Volumes:"
CMD="df"
MATCH=".snapshot|Filesystem|snap reserve"
get_space_percentage "${USER}" "${FILER}" "${CMD}" "${MATCH}"
