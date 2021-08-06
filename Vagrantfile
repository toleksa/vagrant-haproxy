# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'


Vagrant.configure("2") do |config|

  ##### DEFINE VM #####
  config.vm.define "ha01" do |config|
  config.vm.hostname = "ha01"
  config.vm.box = "centos/8"
  config.vm.box_check_update = false
  config.vm.network "private_network", ip: "192.168.18.11"
  config.vm.provider :libvirt do |v|
    v.memory = 1024
    end
  end
  config.vm.provision "file", source: "~/.ssh/authorized_keys", destination: "~/.ssh/authorized_keys"
end
