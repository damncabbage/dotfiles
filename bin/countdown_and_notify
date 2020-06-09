#!/bin/bash -eu

[[ -z "${1:-}" ]] && (
  echo "Usage: $0 minutes";
  echo "eg.    $0 5";
  exit 1
);

countdown_and.sh "$1" "say 'It has been $1 minutes.'; terminal-notifier -message '$1 minutes is up!'"
