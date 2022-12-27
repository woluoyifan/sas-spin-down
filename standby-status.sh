#!/bin/bash

# lists current status of SAS disk drives
# require package: sg3-utils

# --bin--
SDPARM=/usr/bin/sdparm
# --bin--


for DISK in $(ls -la /dev/disk/by-path/*-sas-* | egrep -v "part[0-9]+ " |sed 's/.*\///') ; do

STATUS=$($SDPARM -C sense /dev/$DISK)
echo "$STATUS"
printf "\n"

done
