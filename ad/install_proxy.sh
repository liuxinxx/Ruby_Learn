#!/bin/sh
sudo chmod u+x ./install_proxy.sh
cd ~
sudo apt-get update
echo Y | sudo apt-get install curl
echo Y | sudo apt-get install squid3
echo Y | sudo apt-get install apache2-utils
cd /etc/squid3
sudo rm -f squid3.conf
curl -O 'https://raw.githubusercontent.com/myvary/Ruby_Learn/master/ad/squid.conf'
sudo htpasswd  -c  /etc/squid3/passwd  mc_proxy
echo mancao
echo mancao
sudo squid3 -k reconfigur
sudo service squid3 restart
