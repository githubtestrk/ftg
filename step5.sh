#!/bin/bash
printf "Installing HTTP Proxy Server privoxy"
read

yum install privoxy -y

cp /etc/privoxy/config /etc/privoxy/config.bak
sed -i 's/listen-address  127.0.0.1:8118/listen-address  0.0.0.0:3128/g' /etc/privoxy/config

service privoxy restart
cat /etc/privoxy/config|grep 3128

exit 0