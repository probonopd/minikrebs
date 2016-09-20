#!/bin/sh
logger "$@"
STATUS=
case $3 in
  FAULT)
	STATUS=": we are fucked i suppose?"
	# TODO: maybe restart system
    ;;
  BACKUP)
	STATUS=": Restarted uhub to force user reconnection (in background)"
	(/etc/init.d/uhub stop; sleep 20; /etc/init.d/uhub start) &
    ;;
  MASTER)
	STATUS=": Updated hub.nsupdate.info - $(update-hub-dns.sh)"
    ;;
esac

irc-announce "I've switched to $3 state $STATUS" >/dev/null 2>&1
