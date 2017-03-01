#!/bin/bash
# Create an opinionated Ubuntu 16.04 VM disk to host redmine, using virt-builder.
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
REDMINE_PASSWORD=$(date +%s%N | sha256sum | base64 | head -c 32)



# Simple file check (race condition prone)
if [ -e "$IMAGENAME" ]
then
  echo "File $IMAGENAME already exists, exiting!"
  exit 1
fi

# /etc/default/grub manipulation and run-command definition from:
# `virt-builder --notes ubuntu-16.04`
virt-builder \
  ubuntu-16.04 \
  --output "$IMAGENAME" \
  --format qcow2 \
  --hostname "$GUESTNAME" \
  --edit '/etc/default/grub:
          s/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,115200n8"/' \
  --run-command "update-grub" \
  --run-command "useradd -G sudo -s /bin/bash -m -p '' redmine"\
  --run-command "echo redmine:$REDMINE_PASSWORD | chpasswd" \
  --firstboot-install "mysql-server" \
  --install "mysql-server,mysql-client,libmysqlclient-dev,git-core,subversion,imagemagick,libmagickwand-dev,libcurl4-openssl-dev" \
  --update \
  --size 20G

# chown -R redmine /var/www

echo "The redmine user has the password: $REDMINE_PASSWORD"
echo "$IMAGENAME created. You can now make friends with virsh, like this: "
echo "sudo virt-install --import --name $GUESTNAME --ram 1024 --disk path=$IMAGENAME,format=qcow2 --os-variant ubuntu16.04 --graphics none --noautoconsole"

# Explicitly exit gracefully
exit 0
