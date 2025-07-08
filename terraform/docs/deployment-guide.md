# OBG Deployment - Terraform Infrastructure Guide

## Overview
This guide covers the deployment of the OBG microservices application using Terraform on AWS infrastructure in the `eu-north-1` region.

## Prerequisites

### Required Tools
- **Terraform** (>= 1.0)
- **AWS CLI** (>= 2.0)
- **Git**

### AWS Permissions
Your AWS account needs the following permissions:
- EC2 (Full access)
- VPC (Full access)
- IAM (Create roles and policies)
- Route53 (DNS management)
- ACM (Certificate management)
- CloudWatch (Monitoring)
- SSM (Systems Manager)

## AWS Credentials Setup

### Option 1: Environment Variables (Recommended for CI/CD)

```bash
# Export AWS credentials
export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
export AWS_DEFAULT_REGION="eu-north-1"
```

### Option 2: AWS CLI Profile (Recommended for Development)

```bash
# Configure AWS CLI profile
aws configure --profile obgdeb

# Use the profile
export AWS_PROFILE="obgdeb"
```

### Option 3: AWS Credentials File
```bash
# Create/edit ~/.aws/credentials
[obgdeb]
aws_access_key_id = your_access_key
aws_secret_access_key = your_secret_key

# Create/edit ~/.aws/config
[profile obgdeb]
region = eu-north-1
output = json
```

## Infrastructure Components

### What Gets Deployed:
1. **VPC** with public and private subnets 
2. **NAT Gateway** with Elastic IP for outbound internet access
3. **EC2 Instance** (t3.large) in private subnet
4. **IAM Role** with SSM and CloudWatch permissions
5. **Security Groups** for HTTP/HTTPS traffic
6. **Application Load Balancer** with HTTPS termination spanning all AZs
7. **ACM Certificate** for `obgdeb.com` and `*.obgdeb.com`
8. **Route53 DNS Records** (wildcard and main domain)
9. **CloudWatch Monitoring** with alarms

### Architecture Notes:
- **Multi-AZ**: High availability, redundancy, and fault tolerance
- **No Public IPs on EC2**: All access via ALB
- **NAT Gateway**: Ensures private subnets have outbound internet
- **ALB Health Check**: Uses `/` path for all targets

## Deployment Steps

### 1. Initialize Terraform
```bash
cd terraform
terraform init
```

### 2. Provision Core Infrastructure (VPC, EIP, ACM Certificate)
Before running a full plan/apply, provision the VPC, EIP, and ACM certificate first. This ensures that DNS and certificate validation can complete before dependent resources are created.

```bash
terraform plan -target=module.vpc -target=module.eip -target=module.acm
terraform apply -target=module.vpc -target=module.eip -target=module.acm
```

### 3. Review the Full Plan
```bash
terraform plan
```

### 4. Apply the Full Infrastructure
```bash
terraform apply
```

### 5. Verify Deployment
```bash
# Check EC2 instance status
terraform output ec2_instance_id

# Check DNS records
terraform output hosted_zone_id

# Check certificate status
terraform output certificate_arn

# Check ALB information
terraform output alb_dns_name
terraform output alb_zone_id
```

## Post-Deployment

### Access the Application
- **Open Banking Gateway**: https://obg.obgdeb.com
- **Fintech UI**: https://fintech-ui.obgdeb.com
- **Fintech Server**: https://fintech-server.obgdeb.com
- **Consent UI**: https://consent.obgdeb.com
- **HBCI Sandbox**: https://sandbox.obgdeb.com

### Health Check
The ALB health check is configured to use `/` endpoint. Ensure your application serves content at the root path for proper health monitoring.


### EC2 Instance Access
```bash
# Using AWS Systems Manager (SSM)
aws ssm start-session --target <instance-id> --profile obgdeb

# Check application status
docker ps
docker-compose ps
```

### Monitoring
- **CloudWatch Logs**: `/aws/ec2/obgdeb-app-server/`
- **Alarms**: CPU utilization > 80%
- **Metrics**: CPU, Memory, Disk usage

## Environment Variables

### Required Environment Variables
```bash
# AWS Configuration
export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
export AWS_DEFAULT_REGION="eu-north-1"

# Or use profile
export AWS_PROFILE="obgdeb"
```

### Optional Environment Variables
```bash
# Terraform Configuration
export TF_VAR_environment="dev"
export TF_LOG="INFO"
export TF_LOG_PATH="terraform.log"
```

## Security Best Practices

### ✅ Do's:
- Use IAM roles instead of access keys when possible
- Enable CloudTrail for audit logging
- Use VPC with private subnets
- Enable CloudWatch monitoring
- Use ACM certificates for HTTPS
- Implement least privilege access

### ❌ Don'ts:
- Don't commit credentials to version control
- Don't use root AWS account credentials
- Don't expose EC2 instances directly to internet
- Don't disable security groups
- Don't use HTTP instead of HTTPS

## Troubleshooting

### Common Issues:

#### 1. Certificate Validation Fails
```bash
# Check DNS records
aws route53 list-resource-record-sets --hosted-zone-id <zone-id>

# Check certificate status
aws acm describe-certificate --certificate-arn <cert-arn>
```

#### 2. EC2 Instance Not Accessible
```bash
# Check security groups
aws ec2 describe-security-groups --group-ids <sg-id>

# Check instance status
aws ec2 describe-instances --instance-ids <instance-id>
```

#### 3. DNS Not Resolving
```bash
# Check Route53 records
aws route53 list-resource-record-sets --hosted-zone-id <zone-id>

# Test DNS resolution
nslookup obgdeb.com
dig *.obgdeb.com
```

#### 4. Docker Images Fail to Pull
```bash
# Check Docker Compose logs for errors
docker-compose logs
```

#### 5. Forcing EC2 Instance Recreation
If you need to force Terraform to recreate the EC2 instance (for example, after changing the AMI, user data, or other critical settings), use the following command:

```bash
terraform taint 'module.ec2.module.ec2_instance.aws_instance.this[<index>]'
```

Replace `<index>` with the instance number. Then re-run `terraform apply` to recreate the instance.

## Cleanup

### Destroy Infrastructure
```bash
# Review what will be destroyed
terraform plan -destroy

# Destroy all resources
terraform destroy
```

### Manual Cleanup (if needed)
```bash
# Delete Route53 records manually
aws route53 delete-hosted-zone --id <zone-id>

# Delete ACM certificate
aws acm delete-certificate --certificate-arn <cert-arn>
```

## Cost Estimation
For a detailed and up-to-date estimate, use the [AWS Pricing Calculator](https://calculator.aws/#/) and include:
- 1x EC2 (t3.large)
- 1x ALB
- 1x NAT Gateway
- 1x Elastic IP
- Data transfer, Route53, ACM, CloudWatch, etc.

## Support

For issues or questions:
1. Check CloudWatch logs
2. Review Terraform state: `terraform show`
3. Check AWS Console for resource status
4. Review this documentation

## Version History

- **v1.0**: Initial deployment with basic infrastructure
- **v1.1**: Added CloudWatch monitoring and alarms
- **v1.2**: Enhanced security groups and IAM roles 