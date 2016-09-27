#!/bin/sh

set -ef

HUB=uhub
if ! pidof $HUB >/dev/null; then
  echo "$HUB is dead"
  exit 1
fi

. /lib/functions/network.sh
network_get_ipaddr ip wan
if test -z "$ip"; then
	echo "WAN has no ip address assigned"
  exit 1
fi

