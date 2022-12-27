#!/bin/bash

# let's SAS disk save power
# require package: sg3-utils
#
# command like: sdparm --flexible -6 -p po -l /dev/sda
#
# target status sample:
#
#  PM_BG         0  [cha: y, def:  0, sav:  0]  Power management, background functions, precedence
#  STANDBY_Y     0  [cha: y, def:  0, sav:  0]  Standby_y timer enable
#  IDLE_C        1  [cha: y, def:  0, sav:  0]  Idle_c timer enable
#  IDLE_B        1  [cha: y, def:  0, sav:  0]  Idle_b timer enable
#  IDLE          1  [cha: y, def:  0, sav:  0]  Idle_a timer enable
#  STANDBY       1  [cha: y, def:  0, sav:  1]  Standby_z timer enable
#  ICT           20  [cha: y, def: 20, sav: 20]  Idle_a condition timer (100 ms)
#  SCT           12000  [cha: y, def:  0, sav:6000]  Standby_z condition timer (100 ms)
#  IBCT          6000  [cha: y, def:6000, sav:1200]  Idle_b condition timer (100 ms)
#  ICCT          9000  [cha: y, def:  0, sav:2400]  Idle_c condition timer (100 ms)
#  SYCT          0  [cha: y, def:  0, sav:  0]  Standby_y condition timer (100 ms)
#  CCF_IDLE      1  [cha: y, def:  1, sav:  1]  check condition on transition from idle
#  CCF_STAND     1  [cha: y, def:  1, sav:  1]  check condition on transition from standby
#  CCF_STOPP     2  [cha: y, def:  2, sav:  2]  check condition on transition from stopped
#
# !! Time should be set to greater than 120 seconds ( 12000ms / value=12000 ) !!
# see:
# https://www.seagate.com/files/docs/pdf/en-GB/whitepaper/tp608-powerchoice-tech-provides-gb.pdf
#
# PowerChoice Technology Manufacturer Default Power Condition Timer Values
# Default Power Condition timer values have been established to ensure product reliability and data
# integrity. A minimum timer value threshold of two minutes ensures that the appropriate amount of
# background drive maintenance activities occur. Attempting to set a timer value less than the specified
# minimum timer value threshold results in an aborted EPC “Set Power Condition Timer” subcommand.

# --config--
IDLEA=1
IDLEA_TIME=20
IDLEB=1
IDLEB_TIME=6000
IDLEC=1
IDLEC_TIME=9000
STANDBY=1
STANDBY_TIME=12000
# --config--
# --bin--
SDPARM=/usr/bin/sdparm
# --bin--

(
  # SAS device filter
for DISK in $(ls -la /dev/disk/by-path/*-sas-* | egrep -v "part[0-9]+ " |sed 's/.*\///') ; do
  sdparm --set IDLE=$IDLEA,ICT=$IDLEA_TIME,IDLE_B=$IDLEB,IBCT=$IDLEB_TIME,IDLE_C=$IDLEC,ICCT=$IDLEC_TIME,STANDBY=$STANDBY,SCT=$STANDBY_TIME -S /dev/$DISK
  $SDPARM --flexible -6 -p po -l /dev/$DISK
done
) &