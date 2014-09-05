#!/bin/bash

# Description: Check Fujitsu RAID status
# Requires: 
# * Install ServerView_RAID Manager Software
# * Start Daemon for ServerView RAID Manager (aurad)
# Version: 20140905

# Software:
# * FUJITSU Software Serverview Suite: 
#   http://support.ts.fujitsu.com/prim_supportcd/
# * Community Linux
#   ftp://ftp.ts.fujitsu.com/community-linux

export LD_LIBRARY_PATH="/opt/fujitsu/ServerViewSuite/RAIDManager/bin/"
/opt/fujitsu/ServerViewSuite/RAIDManager/bin/amCLI -l all | grep "Status overall"
