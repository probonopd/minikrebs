#!/bin/sh
set -xeu

cd bin/*
ls -altrh
# VDI
echo "Converting image to Virtualbox" > 2

SIMG=`ls -1 *-combined-squashfs.img`
VBoxManage convertfromraw "$SIMG" "${SIMG%.img}.vdi" --format VDI

echo "converting image to qcow2"
EGIMG=`ls -1 *-combined-ext4.img.gz`
EIMG=${EGIMG%.gz}
gunzip "$EGIMG"
qemu-img convert "$EIMG" -O qcow2 "${EIMG%.img}.qcow2"
gzip "$EIMG"

cd -
