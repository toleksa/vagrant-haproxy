#!/bin/bash

set -e

yum -y update
yum install -y libvirt libvirt-devel ruby-devel gcc qemu-kvm libguestfs-tools make rsync bridge-utils
systemctl start libvirtd
systemctl enable libvirtd
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install vagrant

function _bugs-centos83 {
    yum install -y wget byacc cmake gcc-c++ zlib-devel rpm-build
    OLDDIR=`pwd`
    cd /tmp

    #https://github.com/hashicorp/vagrant/issues/11020
    #dnf download --source libssh

    git clone https://git.centos.org/centos-git-common
    # centos-git-common needs its tools in PATH
    export PATH=$(readlink -f ./centos-git-common):$PATH
    git clone https://git.centos.org/rpms/libssh
    cd libssh
    git checkout imports/c8s/libssh-0.9.4-2.el8
    into_srpm.sh -d c8s
    cd SRPMS

    rpm2cpio libssh-0.9.4*.src.rpm | cpio -imdV
    tar xf libssh-0.9.4.tar.xz
    mkdir build
    cd build
    cmake ../libssh-0.9.4 -DOPENSSL_ROOT_DIR=/opt/vagrant/embedded/
    make
    cp lib/libssh* /opt/vagrant/embedded/lib64
    cd /tmp
    rm -rf centos-git-common/ libssh/

    #https://github.com/vagrant-libvirt/vagrant-libvirt/issues/1127
    #dnf download --source krb5-libs

    git clone https://git.centos.org/centos-git-common
    # centos-git-common needs its tools in PATH
    export PATH=$(readlink -f ./centos-git-common):$PATH
    git clone https://git.centos.org/rpms/krb5
    cd krb5
    git checkout imports/c8s/krb5-1.18.2-8.el8
    into_srpm.sh -d c8s
    cd SRPMS

    rpm2cpio krb5-1.18.2*.src.rpm | cpio -imdV
    tar xf krb5-1.18.2.tar.gz
    cd krb5-1.18.2/src
    LDFLAGS='-L/opt/vagrant/embedded/' ./configure
    make
    cp -a lib/crypto/libk5crypto.* /opt/vagrant/embedded/lib64/
    cd /tmp
    rm -rf centos-git-common/ krb5/

    cd $OLDDIR ; unset OLDPWD
}

if ! vagrant plugin list | grep libvirt > /dev/null 2>&1; then
    _bugs-centos83
    #export CONFIGURE_ARGS="with-libvirt-include=/usr/include/libvirt with-libvirt-lib=/usr/lib64"
    vagrant plugin install vagrant-libvirt
fi

vagrant plugin list

