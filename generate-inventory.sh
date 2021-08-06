#!/bin/bash

if [ "$PUB_IP_CLASS" == '' ]; then 
    echo "ERR: PUB_IP_CLASS not set"
    echo "example: export PUB_IP_CLASS=192.168.0.21"
    exit 1
fi

vagrant ssh-config | grep -E "^Host|HostName " | tr '\n' ' ' | sed -e 's/HostName//g' | sed -e 's/Host/\n/g' | grep -Ev '^$' > temp-inventory

HOSTS_HA="[haproxy]|"
HOSTS_WEB="[web]|"

HA_COUNTER=0
WEB_COUNTER=0
cp template-haproxy.cfg haproxy.j2
while read LINE; do
    NAME=`echo $LINE | gawk '{ print $1 }'`
    IP=`echo $LINE | gawk '{ print $2 }'`

    if echo $LINE | grep -E "^ha" > /dev/null; then
        HA_COUNTER=$((HA_COUNTER+1))
        HOSTS_HA="${HOSTS_HA}${IP} num=${HA_COUNTER} public_ip=${PUB_IP_CLASS}${HA_COUNTER}|"
    fi
    if echo $LINE | grep -E "^web" > /dev/null; then
        WEB_COUNTER=$((WEB_COUNTER + 1))
        HOSTS_WEB="${HOSTS_WEB}${IP}|"
        echo "       server web${WEB_COUNTER} ${IP}:80 check" >> haproxy.j2
    fi
done < temp-inventory

echo $HOSTS_HA | sed -e 's/|/\n/g' > inventory
echo $HOSTS_WEB | sed -e 's/|/\n/g' >> inventory

rm temp-inventory

