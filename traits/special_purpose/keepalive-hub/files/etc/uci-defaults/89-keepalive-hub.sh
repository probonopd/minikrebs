#!/bin/sh
cd /pkgs
for i in *.ipk;do
  opkg install $i && rm $i
done

/etc/init.d/uhub enable
/etc/init.d/keepalived enable
