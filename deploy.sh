#!/bin/bash
#
# starting point for deployment - fire&forget
#

set -e

export PUB_IP_CLASS="192.168.0.21"
export PUB_GATEWAY="192.168.0.1"
export WORLD_IFACE="enp0s3"

export HA_NODES="2"
export WEB_NODES="3"

./setup-bridge.sh
./install-vagrant.sh
vagrant up
./generate-inventory.sh
yum install -y ansible
ANSIBLE_HOST_KEY_CHECKING=False ansible -i inventory -m ping all
ansible-playbook -i inventory ansible.yml
 
