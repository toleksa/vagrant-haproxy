#!/bin/bash

if [ "$WOLRD_IFACE" == '' ]; then
    echo "ERR: WORLD_IFACE not set"
    echo "example: export WORLD_IFACE=enp0s3"
    exit 1
fi

MAC=`ip address show dev $WOLRD_IFACE | awk '$1=="link/ether" {print $2}'`

cat >/etc/sysctl.d/bridge.conf <<'EOF'
net.bridge.bridge-nf-call-ip6tables=0
net.bridge.bridge-nf-call-iptables=0
net.bridge.bridge-nf-call-arptables=0
EOF

cat >/etc/udev/rules.d/99-bridge.rules <<'EOF'
ACTION=="add", SUBSYSTEM=="module", KERNEL=="bridge", RUN+="/sbin/sysctl -p /etc/sysctl.d/bridge.conf"
EOF

yum install -y bridge-utils

cp /etc/sysconfig/network-scripts/ifcfg-${WORLD_IFACE} /etc/sysconfig/network-scripts/ifcfg-${WORLD_IFACE}-orig

cat >/etc/sysconfig/network-scripts/ifcfg-${WORLD_IFACE} <<'EOF'
DEVICE=eth0
NAME=eth0
NM_CONTROLLED=yes
ONBOOT=yes
TYPE=Ethernet
BRIDGE=br0
EOF

echo "HWADDR=$MAC" >> /etc/sysconfig/network-scripts/ifcfg-${WORLD_IFACE}

cat >/etc/sysconfig/network-scripts/ifcfg-br0 <<'EOF'
DEVICE=br0
NAME=br0
NM_CONTROLLED=yes
ONBOOT=yes
TYPE=Bridge
STP=off
DELAY=0
BOOTPROTO=dhcp
DEFROUTE=yes
EOF

nmcli connection reload
nmcli connection down eth0 && nmcli connection up eth0

