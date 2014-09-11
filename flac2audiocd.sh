#!/bin/bash

# Description: 2 seconds gapless audio CD creation from flac.
# https://wiki.archlinux.org/index.php/Gapless_Audio_CD_Creation_from_MP3s
# Requires: flac cdrdao
# Version: 20140911

. colors.sh

usage() {
cat << EOF
flac2audiocd 0.1
Gapless audio CD creation using cdrdao
Usage: $0 <path>
EOF
exit 1
}

# args
if [ -z "$1" ]
    then
        echo "No argument supplied"
        usage
fi

# flac?
if [ ! -f /usr/bin/flac ] ; then
    echo "flac command not found, please install flac."
    exit 1
fi

# cdrdao?
if [ ! -f /usr/bin/cdrdao ] ; then
    echo "flac command not found, please install flac."
    exit 1
fi

# path
cd "$1"

# Song names with spaces
echo -en "\n\b"

# flac -> wav
echo_h1 "Decoding songs..."
for f in *.flac ; do
    echo_h2 "$f"
    flac --decode -s "$f"
done

# toc
echo_h1 "Writing TOC..."
{
    echo "CD_DA"
    for file in *.wav ; do
        echo "TRACK AUDIO"
        echo "FILE \"$file\" 0"
    done
} > toc

# cdrdao
echo_h1 "Recording songs..."
cdrdao write --speed 8 --device /dev/cdrom toc

# eject
echo_h1 "Ejecting CD..."
eject /dev/cdrom

# clean
echo_h1 "Cleaning..."
rm ./*.wav toc
