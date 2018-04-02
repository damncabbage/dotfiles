#!/bin/bash -eu

if [ -z "$1" ]; then
  echo "Usage: $0 message"
  exit 1
fi

TITLE="====="
if [ ! -z "${2-}" ]; then
  TITLE="$2"
fi

osascript -e "display notification \"$1\" with title \"$TITLE\""
