#!/bin/bash

# LDAP searches in Active Directory
# Requires: ldapsearch (openldap-clients)

LDAP_USER="cn=user_example,cn=Users,dc=domain_example,dc=com"
LDAP_PASS="PASSWORD"
LDAP_SERVER="server.domain_example.com"
LDAP_BASE="DC=domain_example,DC=com"

usage() {
cat << EOF
Usage: $0 [login] [filter]
EOF
}

if [ $# -gt "2" ] ; then
    usage
elif [ $# = 0 ] ; then
    ldapsearch -w $LDAP_PASS -D $LDAP_USER -h $LDAP_SERVER -b $LDAP_BASE "(objectclass=*)"
elif [ $# = 1 ] ; then
    ldapsearch -w $LDAP_PASS -D $LDAP_USER -h $LDAP_SERVER -b $LDAP_BASE "(sAMAccountName=$1)"
elif [ $# = 2 ] ; then
    ldapsearch -w $LDAP_PASS -D $LDAP_USER -h $LDAP_SERVER -b $LDAP_BASE "(sAMAccountName=$1)" $2
fi

