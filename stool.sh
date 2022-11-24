#!/bin/bash

if [ "$1" = "-v" ]; then
  sdparm --flexible -6 -p po -l /dev/"$2"
fi

if [ "$1" = "-s" ]; then
  sdparm --flexible -6 -v -S -p po -s "$2"="$3" /dev/"$4"
fi