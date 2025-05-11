#!/bin/bash

# Update and install packages
sudo yum update -y
sudo yum install -y git docker
sudo amazon-linux-extras enable nginx1
sudo yum install -y nginx

# Start and enable services
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl enable nginx
sudo systemctl start nginx

# Add ec2-user to docker group
sudo usermod -aG docker ec2-user

# Clone your app repository
cd /home/ec2-user
sudo git clone https://github.com/Khhafeez47/nodeapp-iba.git
sudo chown -R ec2-user:ec2-user nodeapp-iba

# Build and run the Docker container
cd nodeapp-iba
sudo docker build -t nodeapp .
sudo docker run -d -p 5000:5000 nodeapp

# Create NGINX reverse proxy config
cat <<EOF | sudo tee /etc/nginx/conf.d/nodeapp.conf
server {
    listen 80;
    server_name ali-aws1.devopsagent.online;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Restart NGINX to apply the new config
sudo nginx -t && sudo systemctl restart nginx