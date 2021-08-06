# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'
ENV['VAGRANT_NO_PARALLEL'] = 'yes'

PUB_IP_CLASS=ENV['PUB_IP_CLASS']

Vagrant.configure("2") do |config|

  (1..2).each do |n|
    config.vm.define "ha#{n}" do |config|
      config.vm.hostname = "ha#{n}"
      config.vm.box = "centos/8"
      config.vm.box_check_update = false
      config.vm.network "public_network", ip: "#{PUB_IP_CLASS}#{n}", type: "bridge", dev: "br0", mode: "bridge"
      config.vm.provider :libvirt do |v|
        v.memory = 512
      end
      config.vm.provision "file", source: "~/.ssh/authorized_keys", destination: "~/.ssh/authorized_keys-additional"
      config.vm.provision "shell", inline: "cat ~/.ssh/authorized_keys-additional >> ~/.ssh/authorized_keys ; rm -rf ~/.ssh/authorized_keys-additional", privileged: false
      config.vm.provision "shell", inline: 'mkdir -p /root/.ssh ; cat /home/vagrant/.ssh/authorized_keys > /root/.ssh/authorized_keys'
      config.vm.provision "shell", inline: 'yum install -y psmisc'
    end
  end

  (1..3).each do |n|
    config.vm.define "web#{n}" do |config|
      config.vm.hostname = "web#{n}"
      config.vm.box = "centos/8"
      config.vm.box_check_update = false
      config.vm.provider :libvirt do |v|
        v.memory = 512
      end
      config.vm.provision "file", source: "~/.ssh/authorized_keys", destination: "~/.ssh/authorized_keys-additional"
      config.vm.provision "shell", inline: "cat ~/.ssh/authorized_keys-additional >> ~/.ssh/authorized_keys ; rm -rf ~/.ssh/authorized_keys-additional", privileged: false
      config.vm.provision "shell", inline: 'mkdir -p /root/.ssh ; cat /home/vagrant/.ssh/authorized_keys > /root/.ssh/authorized_keys'
    end
  end
end

