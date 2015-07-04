#!/bin/bash
printf "Install and configure firewalld"
read

yum install firewalld -y
cat << _EOF_ > /etc/firewalld/services/fuckgfw.xml
<service>
  <short>fuckgfw</short>
  <description>fuck the gfw</description>
  <port protocol="tcp" port="22"/>
  <port protocol="tcp" port="80"/>
  <port protocol="tcp" port="443"/>
  <port protocol="tcp" port="1723"/>
  <port protocol="tcp" port="3128"/>
  <port protocol="tcp" port="3288"/>
  <port protocol="tcp" port="3289"/>
  <port protocol="tcp" port="10443"/>
</service>
_EOF_

service firewalld restart
firewall-cmd --permanent --zone=public --add-service=fuckgfw
firewall-cmd --permanent --add-masquerade
firewall-cmd --reload

#enable ip forward
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

#configure dns resolv
cp /etc/resolv.conf /etc/resolv.conf.bak
cat /etc/resolv.conf|grep -v "nameserver" > /tmp/tmp.ftgw.resolv.conf
cat /tmp/tmp.ftgw.resolv.conf > /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf

rm -rf /tmp/tmp.ftgw.resolv.conf
exit 0
