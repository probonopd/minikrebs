#!/bin/sh
logger "$@"
# TODO: timeout from configuration
TIMEOUT=120
STATUS=
case $3 in
  FAULT)
	# TODO: maybe restart system
    ;;
  BACKUP)
	STATUS=": Scheduling uhub restart to force user reconnection (in $TIMEOUT seconds)"
  (sleep $TIMEOUT; /etc/init.d/uhub stop;/etc/init.d/uhub start)&
    ;;
  MASTER)
	STATUS=": updated hub.nsupdate.info - $(update-hub-dns.sh)"
    ;;
esac

irc-announce "switched to $3 state $STATUS" >/dev/null 2>&1
