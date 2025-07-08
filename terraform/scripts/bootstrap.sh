#!/bin/bash
set -eux

# Update system
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Docker
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

# Add ubuntu user to docker group for non-sudo access but we can also avoid this so that you always use sudo, making sure that you can't delete something by mistake
sudo usermod -aG docker ubuntu

# Install Docker Compose v2
sudo curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Git
sudo apt-get install -y git

# Install AWS CLI for SSM access (optional, can be removed if not needed)
# sudo apt-get install -y awscli

# Clone your Docker Compose deployment
cd /home/ubuntu
git clone https://github.com/ADORSYS-GIS/obg-deployment.git
cd obg-deployment

# Run the stack
docker-compose up -d

# Verify containers are running
echo "Checking container status..."
docker-compose ps

# Show logs if any containers failed
if [ $? -ne 0 ]; then
    echo "Some containers failed to start. Checking logs..."
    docker-compose logs
fi
