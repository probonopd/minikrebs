#!/bin/sh
set -euf
sed -i 's#Device/tplink-4mlzma#Device/tplink-16mlzma#'   target/linux/ar71xx/image/Makefile
