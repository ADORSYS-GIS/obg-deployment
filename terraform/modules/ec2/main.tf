terraform {
  required_version = ">= 1.3.0"
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.5"

  name = var.name

  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = false

  iam_instance_profile = var.iam_instance_profile_name
  user_data            = file(var.user_data_path)

  monitoring    = true
  ebs_optimized = true

  tags = var.tags
}

