#!/bin/bash
sudo rm -rf /var/lib/cloud/*


sudo apt update
sudo apt upgrade -y
sudo apt install nginx wget curl -y
sudo cat > /etc/nginx/conf.d/load-balancer.conf <<EOF
# Define which servers to include in the load balancing scheme. 
# It's best to use the servers' private IPs for better performance and security.
# You can find the private IPs at your UpCloud control panel Network section.
http {
    upstream backend {
      server "${private_ip1}"; 
      server "${private_ip2}";
  }

# This server accepts all traffic to port 80 and passes it to the upstream. 
# Notice that the upstream name and the proxy_pass need to match.

server {
      listen 80; 

      location / {
          proxy_pass http://backend;
      }
    }
}
EOF

sudo rm /etc/nginx/sites-enabled/default
sudo systemctl restart nginx
