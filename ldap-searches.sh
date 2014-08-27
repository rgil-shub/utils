#!/bin/bash

# Common LDAP searches
# Requires: ldapsearch (openldap-clients)

if [ ! -f /usr/bin/ldapsearch ] ; then
    echo "ldapsearch command not found, please install openldap-clients."
    exit 1
fi

LDAP_USER="cn=user_example,cn=Users,dc=domain_example,dc=com"
LDAP_PASS="PASSWORD"
LDAP_SERVER="server.domain_example.com"
LDAP_BASE="DC=domain_example,DC=com"

OPTIONS="-w $LDAP_PASS -D $LDAP_USER -h $LDAP_SERVER -b $LDAP_BASE"

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

if [ $# -gt "3" ] ; then
    usage
    exit 0
elif [ $# = 0 ] ; then
    # ./ldapsearch
    ldapsearch $OPTIONS "(objectclass=*)"
elif [ $# = 1 ] ; then
    # ./ldapsearch login
    ldapsearch $OPTIONS "(sAMAccountName=$1)"
elif [ $# = 2 ] ; then
    # ./ldapsearch login attribute    
    ldapsearch $OPTIONS "(sAMAccountName=$1)" $2
elif [ $# = 3 ] & [ $1 = "-d" ]; then
    # ./ldapsearch -d login attribute
    ldapsearch $OPTIONS -LLL "(sAMAccountName=$2)" $3 | grep -v refldap | cut -d" " -f2 | base64 -di  
fi

