#!/bin/sh
. /lib/functions/network.sh
set -ef

network_get_ipaddr ip wan
wget -qO- $(uci get announce.nsupdate.url)$ip
