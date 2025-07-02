module "eip" {
  source      = "./modules/eip"
  name        = "nat-eip"
  environment = var.environment
}

module "vpc" {
  source = "./modules/vpc"

  vpc_name         = "obgdeb-vpc-2025"
  vpc_cidr         = "10.0.0.0/16"
  azs              = ["eu-north-1a"]
  private_subnets  = ["10.0.1.0/24"]
  public_subnets   = ["10.0.101.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  reuse_nat_ips        = true
  external_nat_ip_ids  = [module.eip.id]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

module "iam" {
  source = "./modules/iam"

  role_name             = "obgdeb-ec2-role"
  instance_profile_name = "obgdeb-ec2-profile"

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

module "security_group" {
  source = "./modules/security-group"

  name        = "obgdeb-app-sg"
  description = "Security group for OBG application"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

module "ec2" {
  source = "./modules/ec2"

  name                    = "obgdeb-app-server"
  ami_id                  = data.aws_ami.ubuntu.id
  instance_type           = "t3.large"
  subnet_id               = module.vpc.private_subnets[0]
  security_group_id       = module.security_group.security_group_id
  iam_instance_profile_name = module.iam.instance_profile_name
  user_data_path          = "${path.module}/scripts/bootstrap.sh"

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
  depends_on = [module.vpc, module.iam, module.security_group]
}

module "acm" {
  source = "./modules/acm"

  domain_name = "obgdeb.com"
  subject_alternative_names = ["*.obgdeb.com"]

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
  depends_on = [module.vpc]
}

module "dns" {
  source = "./modules/dns"

  domain_name = "obgdeb.com"
  target_domain_name = module.vpc.nat_public_ips[0] # NAT Gateway public IP for A record
  certificate_domain_validation_options = module.acm.certificate_domain_validation_options
  depends_on = [module.acm]
}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  instance_id   = module.ec2.instance_id
  instance_name = "obgdeb-app-server"
  alarms = {
    cpu_utilization = {
      name                = "HighCPUUtilization"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 2
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      period              = 300
      statistic           = "Average"
      threshold           = 80
      description         = "Alarm when CPU exceeds 80%"
      alarm_actions       = []
      ok_actions          = []
    }
  }
  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
  depends_on = [module.ec2]
}



