#!/bin/sh
LOGNAME=keepalived irc-announce "I've switched to $3 state" 2>&1 | tee /tmp/irc-log
logger "$@"
case $3 in
  FAULT)
    ;;
  BACKUP)
    ;;
  MASTER)
    ;;
esac
