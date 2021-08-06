#!/bin/bash

set -x

yum -y update
yum install -y libvirt libvirt-devel ruby-devel gcc qemu-kvm libguestfs-tools make rsync
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install vagrant

#bugs
yum install -y wget byacc cmake gcc-c++
OLDDIR=`pwd`
cd /tmp

    #https://github.com/hashicorp/vagrant/issues/11020
    dnf download --source libssh
    rpm2cpio libssh-0.9.4-2.el8.src.rpm | cpio -imdV
    tar xf libssh-0.9.4.tar.xz
    mkdir build
    cd build
    cmake ../libssh-0.9.4 -DOPENSSL_ROOT_DIR=/opt/vagrant/embedded/
    make
    cp lib/libssh* /opt/vagrant/embedded/lib64
    #ln -sf /opt/vagrant/embedded/lib64/libssl.so.4 /usr/lib64/libssh.so.4

    #https://github.com/vagrant-libvirt/vagrant-libvirt/issues/1127
    dnf download --source krb5-libs
    rpm2cpio krb5-1.18.2-8.el8.src.rpm | cpio -imdV
    tar xf krb5-1.18.2.tar.gz
    cd krb5-1.18.2/src
    LDFLAGS='-L/opt/vagrant/embedded/' ./configure
    make
    cp -a lib/crypto/libk5crypto.* /opt/vagrant/embedded/lib64/
    #ln -sf /opt/vagrant/embedded/lib64/libk5crypto.so.3 /usr/lib64/libk5crypto.so.3

cd $OLDDIR ; unset $OLDPWD
#end bugs

export CONFIGURE_ARGS="with-libvirt-include=/usr/include/libvirt with-libvirt-lib=/usr/lib64"
vagrant plugin install vagrant-libvirt

vagrant plugin list

