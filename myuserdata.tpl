#cloud-boothook
#!/bin/bash
sudo rm -rf /var/lib/cloud/*
sudo cloud-init init
sudo cloud-init modules -m final

sudo apt update
sudo apt upgrade -y
sudo apt install nginx wget curl -y
 

sudo wget https://dl.google.com/go/go1.14.3.linux-amd64.tar.gz
sudo tar -xvf go1.14.3.linux-amd64.tar.gz
sudo mv go /usr/local
sudo echo "
export GOPATH=/go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOPATH
export PATH=$PATH:$GOROOT/bin" >> ~/.profile

sudo curl https://raw.githubusercontent.com/Omkar219/go/master/main.go > /usr/local/go/main.go
cd /usr/local/go/ && go build main.go



sudo echo "
[Unit]
Description=goweb

[Service]
Type=simple
Restart=always
RestartSec=5s
ExecStart=/usr/local/go/main

[Install]
WantedBy=multi-user.target " > /lib/systemd/system/goweb.service

sudo systemctl daemon-reload 
sleep 5
sudo service goweb start
sleep 5


sudo cat > /etc/nginx/sites-available/yourdomain.conf <<EOF
server {
    listen [::]:80;
    listen 80;
    server_name www.yourdomain.com;

    location / {
        proxy_pass http://127.0.0.1:8484;
        proxy_next_upstream error timeout http_502 http_503 http_504;
    }
} 
EOF
sudo nginx -t
sudo ln -s /etc/nginx/sites-available/yourdomain.conf /etc/nginx/sites-enabled/yourdomain.conf
sudo nginx -s reload
sudo rm /etc/nginx/sites-enabled/default
sudo PRIVATE_IP=$(hostname -i)
sudo echo "$${PRIVATE_IP} www.yourdomain.com" >> /etc/hosts
sudo systemctl restart nginx 
sudo systemctl enable nginx


