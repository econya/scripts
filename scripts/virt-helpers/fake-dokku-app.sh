#!/bin/bash

# "Fakes" a dokku 0.8 app that only reverse-proxies (without really firing up a
# container) by creating all files necessary.
# Like this your dokku host can be used to change subdomain(s), setup ssl
# etc.pp. (rich mans nginx configuration)

# Copyright 2017, Felix Wolfsteller
# License: GPLv3+

# Use at your own risk, this is a pretty dirty endavour, bypassing quite some
# dokku awesomeness!

# Exit on errors
set -euo pipefail

if [ $# -ne 3 ]
then
  echo "Need to specify three arguments (name, host, port)!"
  exit 1
fi

APPNAME="$1"
APPHOST="$2"
APPPORT="$3"

APPPATH="/home/dokku/$APPNAME"

if [ -e "$APPPATH" ]
then
  echo "Directory $APPPATH already exists, exiting!"
fi

dokku apps:create "$APPNAME"

echo "$APPPORT" > $APPPATH/PORT.web.1
echo "$APPHOST" > $APPPATH/IP.web.1
echo "" > $APPPATH/CONTAINER

# URLS ?
# VHOST ?

chown -R dokku:dokku $APPPATH

dokku nginx:build-config "$APPNAME"
