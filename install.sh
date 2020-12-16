#!/bin/bash
wget https://github.com/Ostaer/FlexGW/releases/download/v1.1/flexgw-1.1.0-1.el7.centos.x86_64.rpm
sysctl -a | egrep "ipv4.*(accept|send)_redirects" | awk -F "=" '{print $1"= 0"}' >> /etc/sysctl.conf
sed -i 's/^net.ipv4.ip_forward.*//g' /etc/sysctl.conf
echo "net.ipv4.ip_forward = 1">> /etc/sysctl.conf
sysctl -p
yum makecache fast
yum install strongswan openvpn zip curl wget
\cp -fv /usr/local/rc/strongswan.conf /etc/strongswan/strongswan.conf
\cp -fv /usr/local/flexgw/rc/openvpn.conf /etc/openvpn/server/server.conf
sed -i  's/load/#load/g' /etc/strongswan/strongswan.d/charon/dhcp.conf
> /etc/strongswan/ipsec.secrets
systemctl  enable openvpn
systemctl start openvpn  
systemctl enable openvpn-server@server.service
systemctl start openvpn-server@server.service
/etc/init.d/initflexgw 
