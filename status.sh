#!/bin/bash

# lists current status of SAS disk drives
# require package: sg3-utils smartmontools

# --bin--
SG_MAP=/usr/bin/sg_map
SMARTCTL=/usr/sbin/smartctl
SDPARM=/usr/bin/sdparm
# --bin--

DISKS=$(ls /dev/sd[a-z])

for DEVNAME in $DISKS ; do
  # SAS device filter
  if [ "$($SMARTCTL -i $DEVNAME | grep protocol | sed -r 's/.*protocol: *(.*) .*/\1/')" == "SAS" ] ; then

    SGDEVNAME=$($SG_MAP | grep "$DEVNAME" | sed -r 's/(.*)[[:space:]].*/\1/' )
    VENDOR=$($SMARTCTL -i $DEVNAME | grep Vendor | sed -r "s/Vendor:\s*(.*)/\1/")
    PRODUCT=$($SMARTCTL -i $DEVNAME | grep Product | sed -r "s/Product:\s*(.*)/\1/")
    REVISION=$($SMARTCTL -i $DEVNAME | grep Revision | sed -r "s/Revision:\s*(.*)/\1/")
    DISKTITLE="$VENDOR $REVISION $PRODUCT"

    if [ "$SGDEVNAME" != "" ] ; then

        if ! grep -iq "standby condition activated" <<< $($SDPARM --command=sense $DEVNAME) ; then

                echo "$DISKTITLE $SGDEVNAME $DEVNAME active"
        else
                echo "$DISKTITLE $SGDEVNAME $DEVNAME standby"

        fi
    fi

  fi

done