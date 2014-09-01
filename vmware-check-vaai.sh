#!/bin/bash

# Description: Vmware NAS VAAI Support
# Requires: awk (gawk) ssh (openssh-clients)
# Version: 20140901

# => VAAI must be enabled in ESX (output with value "1")
# esxcfg-advcfg -g /DataMover/HardwareAcceleratedMove
# esxcfg-advcfg -g /DataMover/HardwareAcceleratedInit
# => If VAAI is not enabled
# esxcfg-advcfg -s 1 /DataMover/HardwareAcceleratedInit
# esxcfg-advcfg -s 1 /DataMover/HardwareAcceleratedMove

# => NFS storage
# esxcfg-nas -l
# esxcli storage nfs list
# => VAAI datastore support
# /bin/vmkfstools -Ph /vmfs/volumes/${DATASTORE}
# => Enabling Password Free SSH Access on ESXi 5.0
# http://blogs.vmware.com/vsphere/2012/07/enabling-password-free-ssh-access-on-esxi-50.html

USER="root"
HOST="$1"

usage() {
cat << EOF
Usage: $0 [host]
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

# host up?
ping -q -w 1 ${HOST} > /dev/null
if [ $? -ne 0 ] ; then
    echo "Host ${HOST} down !"
    exit 1
fi

# Datastores
ssh ${USER}@${HOST} "esxcli storage nfs list"

DATASTORES=$(ssh ${USER}@${HOST} "esxcfg-nas -l" \
    | grep "mounted available" \
    | awk '{ print $1}')

# VAAI support?
for DATASTORE in $(echo ${DATASTORES});
do
    echo "* Datastore ${DATASTORE}"
    ssh ${USER}@${HOST} \
        "/bin/vmkfstools -Ph /vmfs/volumes/${DATASTORE}" \
        | grep -P "NAS VAAI Supported|Is Native Snapshot Capable"
done
