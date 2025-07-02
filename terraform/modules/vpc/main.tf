module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.2"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  reuse_nat_ips        = var.reuse_nat_ips
  external_nat_ip_ids  = var.external_nat_ip_ids

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.tags
}

