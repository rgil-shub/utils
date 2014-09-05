#!/bin/bash

# Check Fujitsu RAID status
# Version: 20140827
# Requires: ServerView_RAID Manager RPM
# FUJITSU Software Serverview Suite: 
# http://support.ts.fujitsu.com/prim_supportcd/

export LD_LIBRARY_PATH="/opt/fujitsu/ServerViewSuite/RAIDManager/bin/"
/opt/fujitsu/ServerViewSuite/RAIDManager/bin/amCLI -l all | grep "Status overall"
