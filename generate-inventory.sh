#!/bin/bash
#
# generates inventory and haproxy.j2 for ansible
#

if [ "$PUB_IP_CLASS" == '' ]; then 
    echo "ERR: PUB_IP_CLASS not set"
    echo "example: export PUB_IP_CLASS=192.168.0.21"
    exit 1
fi

if [ "$PUB_GATEWAY" == '' ]; then
    echo "ERR: PUB_GATEWAY not set"
    echo "example: export PUB_GATEWAY=192.168.0.1"
    exit 1
fi


cp template-haproxy.cfg haproxy.j2

HOSTS_HA="[haproxy]|"
HOSTS_WEB="[web]|"

HA_COUNTER=0
WEB_COUNTER=0
while read LINE; do
    NAME=`echo $LINE | gawk '{ print $1 }'`
    IP=`echo $LINE | gawk '{ print $2 }'`

    if echo $LINE | grep -E "^ha" > /dev/null; then
        HA_COUNTER=$((HA_COUNTER+1))
        HOSTS_HA="${HOSTS_HA}${IP} pri=${HA_COUNTER} node_public_ip=${PUB_IP_CLASS}${HA_COUNTER} gw=${PUB_GATEWAY}|"
    fi
    if echo $LINE | grep -E "^web" > /dev/null; then
        WEB_COUNTER=$((WEB_COUNTER + 1))
        HOSTS_WEB="${HOSTS_WEB}${IP}|"
        echo "       server web${WEB_COUNTER} ${IP}:80 check" >> haproxy.j2
    fi
done < <(vagrant ssh-config | grep -E "^Host|HostName " | tr '\n' ' ' | sed -e 's/HostName//g' | sed -e 's/Host/\n/g' | grep -Ev '^$')

echo $HOSTS_HA | sed -e 's/|/\n/g' > inventory
echo -e "[haproxy:vars]\nfront_public_ip=${PUB_IP_CLASS}0\n\n" >> inventory
echo $HOSTS_WEB | sed -e 's/|/\n/g' >> inventory

