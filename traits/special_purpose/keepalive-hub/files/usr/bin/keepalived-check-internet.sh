#!/bin/sh
# only run every 30 seconds
set -ef

if test -z "$(wget -qO- http://ipv4.nsupdate.info/myip)";then
  echo "unable to retrieve external ip from nsupdate.info"
  exit 1
fi
