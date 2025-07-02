#!/bin/bash

# Script to set up GitHub Container Registry token in SSM Parameter Store
# Usage: ./setup-ghcr-token.sh <your-github-token>

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <your-github-token>"
    echo ""
    echo "This script stores your GitHub token in AWS SSM Parameter Store"
    echo "for secure access by the EC2 instance during deployment."
    echo ""
    echo "To get a GitHub token:"
    echo "1. Go to GitHub Settings > Developer settings > Personal access tokens"
    echo "2. Generate a new token with 'read:packages' scope"
    echo "3. Copy the token and use it as an argument to this script"
    exit 1
fi

GHCR_TOKEN=$1
PARAMETER_NAME="/obgdeb/ghcr/token"

echo "Setting up GitHub Container Registry token in SSM Parameter Store..."

# Store the token in SSM Parameter Store (encrypted)
aws ssm put-parameter \
    --name "$PARAMETER_NAME" \
    --value "$GHCR_TOKEN" \
    --type "SecureString" \
    --description "GitHub Container Registry token for OBG deployment" \
    --region eu-north-1 \
    --overwrite

echo "✅ Successfully stored GHCR token in SSM Parameter Store"
echo "Parameter name: $PARAMETER_NAME"
echo ""
echo "The EC2 instance will now be able to authenticate with GHCR during deployment."
echo ""
echo "To verify the parameter was stored correctly:"
echo "aws ssm describe-parameters --parameter-filters \"Key=Name,Values=$PARAMETER_NAME\" --region eu-north-1" 