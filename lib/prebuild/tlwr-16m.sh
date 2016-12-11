#!/bin/sh
set -xeuf
echo $PWD
ls 
test -e target/linux/ar71xx/image/Makefile
sed -i 's#Device/tplink-4mlzma#Device/tplink-16mlzma#'   target/linux/ar71xx/image/Makefile
