#!/bin/sh
. /lib/functions/network.sh
set -ef
sleep 10
network_get_ipaddr ip wan

while test -z "$ip"; do
	sleep 1
	network_flush_cache
	network_get_ipaddr ip wan
done

ext_ip=$(wget -qO- http://ipv4.nsupdate.info/myip)
irc-announce "Why hello there, this is $HOSTNAME. My WAN ip is $ip, my external ip is $ext_ip. Uptime $(uptime | cut -d\  -f4- |cut -d, -f1 )"
