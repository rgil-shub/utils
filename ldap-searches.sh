#!/bin/bash

# Common LDAP searches
# Requires: ldapsearch (openldap-clients)

LDAP_USER="cn=user_example,cn=Users,dc=domain_example,dc=com"
LDAP_PASS="PASSWORD"
LDAP_SERVER="server.domain_example.com"
LDAP_BASE="DC=domain_example,DC=com"

usage() {
cat << EOF
Common ldapsearches
Usage: $0 [options]
Options:
  login                        All login entries
  login attribute              Filter by attributes
  -d login attribute           Decode base64
EOF
}

OPTIONS="-w $LDAP_PASS -D $LDAP_USER -h $LDAP_SERVER -b $LDAP_BASE"

if [ $# -gt "3" ] ; then
    usage
# ./ldapsearch
elif [ $# = 0 ] ; then
    ldapsearch $OPTIONS "(objectclass=*)"
# ./ldapsearch login
elif [ $# = 1 ] ; then
    ldapsearch $OPTIONS "(sAMAccountName=$1)"
# ./ldapsearch login attribute
elif [ $# = 2 ] ; then
    ldapsearch $OPTIONS "(sAMAccountName=$1)" $2
# ./ldapsearch -d login attribute
elif [ $# = 3 ] & [ $1 = "-d" ]; then
    ldapsearch $OPTIONS -LLL "(sAMAccountName=$2)" $3 | grep -v refldap | cut -d" " -f2 | base64 -di  
fi

