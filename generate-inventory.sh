#!/bin/bash

vagrant ssh-config | grep -E "^Host|HostName " | tr '\n' ' ' | sed -e 's/HostName//g' | sed -e 's/Host/\n/g' | grep -Ev '^$' > temp-inventory

HOSTS_HA="[haproxy]|"
HOSTS_WEB="[web]|"

while read LINE; do
    NAME=`echo $LINE | gawk '{ print $1 }'`
    IP=`echo $LINE | gawk '{ print $2 }'`

    if echo $LINE | grep -E "^ha" > /dev/null; then
        HOSTS_HA="${HOSTS_HA}${IP}|"
    fi
    if echo $LINE | grep -E "^web" > /dev/null; then
        HOSTS_WEB="${HOSTS_WEB}${IP}|"
    fi
done < temp-inventory

echo $HOSTS_HA | sed -e 's/|/\n/g' > inventory
echo $HOSTS_WEB | sed -e 's/|/\n/g' >> inventory

rm temp-inventory

