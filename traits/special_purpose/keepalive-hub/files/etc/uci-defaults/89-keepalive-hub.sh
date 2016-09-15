#!/bin/sh
cd /pkgs
for i in  libevent_1.4.15-1_ar71xx.*.ipk sed_4.2.1-1_ar71xx.*.ipk uhub_0.2.8-3_ar71xx.*.ipk;do
  opkg install $i && rm $i
done

/etc/init.d/uhub enable
/etc/init.d/keepalived enable
