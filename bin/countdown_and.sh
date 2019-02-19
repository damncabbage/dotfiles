#!/bin/bash -eu

[[ -z "${2:-}" ]] && (
  echo "Usage: $0 minutes command-to-run";
  echo "eg.    $0 5 'say \"do the fucking thing goddamnit\"'";
  exit 1
);

SECS=$(($1 * 60));
while [[ "$SECS" > 0 ]]; do
   echo -ne "$SECS\033[0K\r";
   sleep 1;
   SECS=$((SECS - 1));
done

($2);
