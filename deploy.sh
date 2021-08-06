#!/bin/bash

export PUB_IP_CLASS="192.168.0.21"

./install-vagrant.sh
vagrant up
./generate-inventory.sh
yum install -y ansible
ANSIBLE_HOST_KEY_CHECKING=False ansible -i inventory -m ping all
ansible-playbook -i inventory ansible.yml
 
