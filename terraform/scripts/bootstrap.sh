#!/bin/bash
set -eux

# Update system
apt-get update -y
apt-get upgrade -y

# Install Docker
apt-get install -y docker.io
systemctl enable docker
systemctl start docker

# Add ubuntu user to docker group for non-sudo access
usermod -aG docker ubuntu

# Install Docker Compose v2
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install Git
apt-get install -y git

# Install AWS CLI for SSM access
apt-get install -y awscli

# Authenticate with GitHub Container Registry (GHCR)
# Option 1: Using SSM Parameter Store (recommended for production)
if aws ssm get-parameter --name "/obgdeb/ghcr/token" --with-decryption --region eu-north-1 > /dev/null 2>&1; then
    echo "Authenticating with GitHub Container Registry..."
    GHCR_TOKEN=$(aws ssm get-parameter --name "/obgdeb/ghcr/token" --with-decryption --region eu-north-1 --query 'Parameter.Value' --output text)
    echo $GHCR_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
    echo "Successfully authenticated with GHCR"
else
    echo "Warning: GHCR token not found in SSM Parameter Store"
    echo "If you have private images, authentication will be required manually"
fi

# Option 2: Using environment variable (alternative)
# if [ ! -z "$GHCR_TOKEN" ]; then
#     echo "Authenticating with GitHub Container Registry using environment variable..."
#     echo $GHCR_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
# fi

# Clone your Docker Compose deployment
cd /home/ubuntu
git clone https://github.com/kouamschekina/obg-deployment.git
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
