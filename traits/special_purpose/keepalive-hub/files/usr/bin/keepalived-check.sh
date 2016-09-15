#!/bin/sh
HUB=uhub
if ! pidof $HUB >/dev/null; then
  echo "$HUB is dead"
  exit 1
fi
