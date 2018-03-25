#!/bin/bash -e
# A quick-and-dirty timer script; displays counted time in "00h 01m 25s" format.

HOUR=0
MIN=0
SEC=0
while true; do
  printf "%02dh %02dm %02ds" "$HOUR" "$MIN" "$SEC"
  sleep 1
  SEC="$((SEC + 1))"
  if [ $SEC -ge 60 ]; then
    SEC=0
    MIN=$((MIN + 1))
  fi
  if [ $MIN -ge 60 ]; then
    MIN=0
    HOUR=$((HOUR + 1))
  fi
  echo -en '\r'
done
