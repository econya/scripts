#!/bin/bash
# Create an oppinionated bare metal Ubuntu 16.04 VM disk using virt-builder.
# Copyright 2017, Felix Wolfsteller
# License: GPLv3+

# Exit on errors
set -e

if [ $# -ne 1 ]
then
  echo "Need to specify an argument (name)!"
  exit 1
fi

GUESTNAME="$1"
IMAGENAME="$1".qcow2

# Simple file check (race condition prone)
if [ -e "$IMAGENAME" ]
then
  echo "File $IMAGENAME already exists, exiting!"
  exit 1
fi

# /etc/default/grub manipulation and run-command definition from
# virt-builder notes ubuntu-16.04
virt-builder \
  ubuntu-16.04 \
  --output "$IMAGENAME" \
  --format qcow2 \
  --hostname "$GUESTNAME" \
  --edit '/etc/default/grub: s/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,115200n8"/' \
  --edit '/etc/network/interfaces: s/^ens2/ens3/' \
  --run-command update-grub \
  --update \
  --size 20G

# Explicitly exit gracefully
exit 0
