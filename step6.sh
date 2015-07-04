#!/bin/bash
printf "Installing ShadowSocks Server and Socks5 Proxy"
read

yum install python-setuptools -y && easy_install pip
pip install shadowsocks

ipaddress=127.0.0.1
printf "Please input your internet IP Address(1.2.3.4): "
read ipaddress
if [[ -n "${ipaddress}" ]]; then
    ipaddress=${ipaddress}
fi
echo "Got IP Address: ${ipaddress}"

cd ~ && mkdir -p app/shadowsocks && cd app/shadowsocks
rm -rf shadowsocks_*.json

cat << _EOF_ >shadowsocks_s.json
{
    "server":"${ipaddress}",
    "server_port":3288,
    "local_address": "${ipaddress}",
    "local_port":3289,
    "password":"fuckthegfw",
    "timeout":600,
    "method":"aes-256-cfb",
    "fast_open": false,
    "pid-file":"/var/run/shadowsocks_s.pid"
}
_EOF_

cat << _EOF_ >shadowsocks_c.json
{
    "server":"${ipaddress}",
    "server_port":3288,
    "local_address": "${ipaddress}",
    "local_port":3289,
    "password":"fuckthegfw",
    "timeout":600,
    "method":"aes-256-cfb",
    "fast_open": false,
    "pid-file":"/var/run/shadowsocks_c.pid"
}
_EOF_

cat << _EOF_ >ss.sh
#!/bin/sh
cd /root/app/shadowsocks/
res=`ps -ef|grep "sslocal" |grep -v grep|wc -l`
if [ \$res = "0" ];then
  echo "sslocal  is not found"
  sslocal  -c shadowsocks_c.json --fast-open -d start
else
  echo "sslocal  is runing"
fi
  
res=`ps -ef|grep "ssserver" |grep -v grep|wc -l`
if [ \$res = "0" ];then
  echo "ssserver is not found"
  ssserver  -c shadowsocks_s.json --fast-open -d start
else
  echo "ssserver is runing"
fi
_EOF_

chmod +x ss.sh
./ss.sh
printf "To configure crotab, please run:contab -e"
printf "*/5 * * * * /root/app/shadowsocks/ss.sh > /dev/nul"

exit 0