#!/bin/bash
printf "Install and configure pptpd"
read

yum install pptpd -y

cp /etc/ppp/options.pptpd /etc/ppp/options.pptpd.bak
cp /etc/ppp/chap-secrets /etc/ppp/chap-secrets.bak
cp /etc/pptpd.conf /etc/pptpd.conf.bak

echo "logfile /var/log/pptpd.log" >> /etc/ppp/options.pptpd
echo "localip 9.9.0.1" >> /etc/pptpd.conf
echo "remoteip 9.9.0.10-200" >> /etc/pptpd.conf
echo "vpn * fuckthegfw *" > /etc/ppp/chap-secrets

systemctl enable pptpd
systemctl start pptpd
netstat -an|grep "1723"|grep "LISTEN"

exit 0