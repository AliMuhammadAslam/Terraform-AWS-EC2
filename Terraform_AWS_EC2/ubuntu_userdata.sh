#!/bin/bash

# Log everything
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1

# Update system
sudo apt update -y && sudo apt upgrade -y

# Install NGINX, Docker, Git
sudo apt install -y nginx docker.io git

# Enable & start services
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl enable docker
sudo systemctl start docker

# Add user to docker group
sudo usermod -aG docker ubuntu

# Clone the app
cd /home/ubuntu
sudo git clone https://github.com/Khhafeez47/nodeapp-iba.git
sudo chown -R ubuntu:ubuntu nodeapp-iba

# Build and run the app
cd nodeapp-iba
sudo docker build -t nodeapp .
sudo docker run -d -p 5000:5000 nodeapp

# NGINX reverse proxy
cat <<EOF | sudo tee /etc/nginx/sites-available/nodeapp
server {
    listen 80;
    server_name ali-aws3.devopsagent.online;

    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection keep-alive;
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/nodeapp /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
sudo systemctl restart nginx
