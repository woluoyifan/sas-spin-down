#!/bin/bash

# lists current status of SAS disk drives
# require package: smartmontools

# --bin--
SMARTCTL=/usr/sbin/smartctl
# --bin--


for DISK in $(ls -la /dev/disk/by-path/*-sas-* | egrep -v "part[0-9]+ " |sed 's/.*\///') ; do
  VENDOR=$($SMARTCTL -i /dev/$DISK | grep Vendor | sed -r "s/Vendor:\s*(.*)/\1/")
  PRODUCT=$($SMARTCTL -i /dev/$DISK | grep Product | sed -r "s/Product:\s*(.*)/\1/")
  REVISION=$($SMARTCTL -i /dev/$DISK | grep Revision | sed -r "s/Revision:\s*(.*)/\1/")
  DISKTITLE="$VENDOR $REVISION $PRODUCT"
  STATUS=$($SMARTCTL -x /dev/$DISK | grep "scan progress" | awk '{print $5" "$6" "$7" "$8" "$9}')

  echo "$DISKTITLE /dev/$DISK $STATUS"

done
