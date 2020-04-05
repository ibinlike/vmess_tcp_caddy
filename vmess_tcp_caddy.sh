#!/bin/bash

echo "Step 1: Install Haproxy 2.1"
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:vbernat/haproxy-2.1
sudo apt update
sudo apt-get install haproxy=2.1.\*
echo "Pull haproxy configuration file and save it to /etc/haproxy/haproxy.cfg"
wget 'https://raw.githubusercontent.com/ibinlike/vmess_tcp_caddy/master/haproxy.cfg'
sudo cp 'haproxy.cfg' /etc/haproxy/haproxy.cfg

echo 'Step 2: Install v2ray'
bash <(curl -L -s https://install.direct/go.sh)
wget 'https://raw.githubusercontent.com/ibinlike/vmess_tcp_caddy/master/config.json' 
sudo cp config.json /etc/v2ray/config.json

echo 'Step 3: Install Caddy'
curl https://getcaddy.com | bash -s personal

echo 'Configure Caddy'
sudo chown root:root /usr/local/bin/caddy
sudo chmod 755 /usr/local/bin/caddy
sudo setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy
sudo mkdir /etc/caddy
sudo chown -R root:root /etc/caddy
sudo mkdir /etc/ssl/caddy
sudo chown -R root:www-data /etc/ssl/caddy
sudo chmod 0770 /etc/ssl/caddy
wget 'https://raw.githubusercontent.com/ibinlike/vmess_tcp_caddy/master/Caddyfile' 
sudo cp caddyfile /etc/caddy/
sudo chown root:root /etc/caddy/Caddyfile
sudo chmod 644 /etc/caddy/Caddyfile
wget 'https://github.com/ibinlike/vmess_tcp_caddy/tree/master/example.com' 
sudo cp example.com /var/www/
sudo chown -R www-data:www-data /var/www/example.com
sudo chmod -R 555 /var/www/example.com

wget 'https://raw.githubusercontent.com/ibinlike/vmess_tcp_caddy/master/caddy.service'
sudo cp caddy.service /etc/systemd/system/caddy.service
sudo chown root:root /etc/systemd/system/caddy.service
sudo chmod 644 /etc/systemd/system/caddy.service
sudo systemctl daemon-reload
sudo systemctl start caddy.service

sudo systemctl enable caddy.service
journalctl --boot -u caddy.service

echo 'Step 4: Install SSL certificates'
cd /etc/ssl/privates
apt-get install socat -y
curl  https://get.acme.sh | sh
#cd /root/.amce.sh

#export CF_Key="刚刚保存下来的KEY"
#export CF_Email="cloudflare的注册邮箱"

#acme.sh --issue --dns dns_cf -d *.你的域名.com -d 你的域名.com --keylength ec-256

#cat ca.crt ca.key > example.com.pem