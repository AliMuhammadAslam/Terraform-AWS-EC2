#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1

# Update system & install
sudo dnf update -y
sudo dnf install -y nginx docker git

# Enable and start services
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl enable docker
sudo systemctl start docker

# Add user to docker group
sudo usermod -aG docker ec2-user

# Clone the app repo
cd /home/ec2-user
sudo git clone https://github.com/Khhafeez47/nodeapp-iba.git
sudo chown -R ec2-user:ec2-user nodeapp-iba

# Build and run Docker container
cd nodeapp-iba
sudo docker build -t nodeapp .
sudo docker run -d -p 5000:5000 nodeapp

# Configure reverse proxy
cat <<EOF | sudo tee /etc/nginx/conf.d/nodeapp.conf
server {
    listen 80;
    server_name ali-aws2.devopsagent.online;

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

sudo systemctl restart nginx