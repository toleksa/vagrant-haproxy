#!/bin/bash

yum install -y libvirt libvirt-devel ruby-devel gcc qemu-kvm libguestfs-tools make
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install vagrant

export CONFIGURE_ARGS="with-libvirt-include=/usr/include/libvirt with-libvirt-lib=/usr/lib64"
vagrant plugin install vagrant-libvirt

vagrant plugin list

