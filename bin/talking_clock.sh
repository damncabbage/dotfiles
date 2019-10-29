#!/bin/bash -eu

shouldSpeak () {
  # Just look for Zoom for now.
  ! pgrep -f zoom.us.*CptHost
}

humanTime () {
  local HOUR
  local MINUTES
  local AM_PM
  HOUR=$(date +%l)
  MINUTES=$(date +%M)
  AM_PM=$(date +%p)
  AM_PM_INITIALS=$(echo "$AM_PM" | tr 'a-z' 'A-Z' | sed 's/\([AP]\)M/\1.M./')
  if [ "$MINUTES" -eq "00" ]; then
    echo "$HOUR o'clock $AM_PM_INITIALS"
  else
    echo "${HOUR}:${MINUTES}${AM_PM}"
  fi
}

findNextMinuteIncrement () {
  local INCR
  local MINUTE
  local SECOND
  INCR=$1
  MINUTE=$(date +%M)
  SECOND=$(date +%S)
  bc -l <<< "scale=0; (${INCR} * 60) - ((${MINUTE} * 60 + ${SECOND}) % (${INCR} * 60))"
}

countdownForNSeconds () {
  local SECS
  SECS=$1
  while [[ "$SECS" > 0 ]]; do
     echo -ne "$SECS\033[0K\r";
     sleep 1;
     SECS=$((SECS - 1));
  done
}


### Script ###

: ${EVERY:=15}

if [ ! -z "${1:-}" ]; then
  EVERY=$1
  echo "Speaking every $EVERY minutes."
else
  echo "Defaulting to speaking every $EVERY minutes."
fi

while true; do
  SLEEP_AMOUNT=$(findNextMinuteIncrement $EVERY)
  echo "The time is: $(date +%H:%M:%S)"
  echo "... Sleeping ${SLEEP_AMOUNT} seconds ($((SLEEP_AMOUNT / 60)) minutes)."
  countdownForNSeconds $SLEEP_AMOUNT

  if shouldSpeak; then
    echo "... Speaking."
    say "The time is $(humanTime)"
  else
    echo "... Shouldn't speak now; staying quiet."
  fi
  echo
done
