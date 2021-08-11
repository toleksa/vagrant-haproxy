# vagrant-haproxy
Automatic haproxy and webserver deployment
* Configure network bridge
* Install Vagrant (including workaround for "undefined symbol: EVP_KDF_ctrl" bug)
* Vagrant deploys VMs
* Based on infrastructure generate config files and inventory for Ansible
* Ansible installs and configures services

## Configuration
### deploy.sh:
```export PUB_IP_CLASS="192.168.1.21"```  AppLB will bind on 192.168.1.21**0** and stats pages will be available on 192.168.1.21**n** for each haproxy node

```export WORLD_IFACE="enp0s3"```   which network card is connected to world

```export HA_NODES="2"``` How many Haproxy nodes deploy

```export WEB_NODES="3"``` How many Webservers deploy

## Launch

```./deploy.sh``` (and go for coffee :) )

## TODO

* Define net bridge in Vagrant
* Separate routing table for public interfaces


