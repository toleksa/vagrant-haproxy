#!/bin/bash
#
# starting point fro deployment - fire&forget
#

set -e

export PUB_IP_CLASS="192.168.1.21"
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
 
