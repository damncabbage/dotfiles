#!/bin/bash -eu

HOUR=$(date +%l)
MINUTES=$(date +%M)
AM_PM=$(date +%p)

if [ "$MINUTES" -eq "00" ]; then
  echo "$HOUR o'clock $AM_PM"
else
  echo "${HOUR}:${MINUTES}${AM_PM}"
fi
