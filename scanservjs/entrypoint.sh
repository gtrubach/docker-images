#!/bin/sh

# Insert a list of net hosts
if [ ! -z "$SANED_NET_HOSTS" ]; then
  hosts=$(echo $SANED_NET_HOSTS | sed "s/;/\n/")
  for host in $hosts; do
    echo $host >> /etc/sane.d/net.conf
  done
fi

# Temp workaround until https://gitlab.alpinelinux.org/alpine/aports/-/issues/12117 is fixed
dbus-daemon --system
avahi-daemon --no-chroot -D

node ./server/server.js
