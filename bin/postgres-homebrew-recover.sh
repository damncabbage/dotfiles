#!/bin/bash -eux

LOCKED=$(pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start 2>&1  | grep -c 'another server might be running')

if [ "$LOCKED" -eq 0 ]; then
  exit 1
  rm /usr/local/var/postgres/postmaster.pid
  pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
  ps x | grep postgres
fi
