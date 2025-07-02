module "iam" {
  source  = "terraform-aws-modules/iam/aws"
  version = "~> 5.0"

  create_role             = true
  role_name               = var.role_name
  role_description        = "EC2 instance role for OBG deployment"
  assume_role_principals  = ["ec2.amazonaws.com"]

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]

  create_instance_profile = true
  instance_profile_name   = var.instance_profile_name

  tags = var.tags
}

data "aws_caller_identity" "current" {} 