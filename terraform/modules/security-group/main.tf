module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  # Inbound rules
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  # Internal container communication
  ingress_with_source_security_group_id = [
    {
      from_port                = 8080
      to_port                  = 9000
      protocol                 = "tcp"
      description              = "Internal container communication"
      source_security_group_id = module.security_group.security_group_id
    }
  ]

  # Egress rules - allow all outbound traffic
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "All outbound traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = var.tags
} 