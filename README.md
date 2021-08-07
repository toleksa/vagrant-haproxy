# vagrant-haproxy
Vagrant to deploy haproxy + web

1. config vars in deploy.sh:
- export PUB_IP_CLASS="192.168.1.21"  (AppLB will bind on 192.168.1.210 and stats will be available on 192.168.1.21n for each haproxy node)
- export WORLD_IFACE="enp0s3"   (which network card is connected to world)

2. optional adjust number of nodes in Vagrantfile, default 2xHaproxy and 3xWeb

3. launch deploy.sh (and go for coffee :) )
