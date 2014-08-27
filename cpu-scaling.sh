#!/bin/bash

# Set the maximum clock frequency in my Lenovo X220
# Version: 20140827

usage() {
cat << EOF
CPU Scaling 0.1 for Lenovo X220
Set the maximum clock frequency
Usage: $0 [800000|1600000|2400000|3200000]
EOF
}

# args
if [ $# -eq 0 ] ; then
    usage
    exit 1
fi

# root?
if [ ! ${EUID} == 0 ] ; then
    echo "Root privileges are required for running CPU Scaling."
    exit 1
fi

echo "* Setting current max frequency ..."
echo "$1" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "$1" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
echo "$1" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
echo "$1" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
echo "$(cat /sys/devices/system/cpu/cpu[0-3]/cpufreq/scaling_max_freq)"
