module "iam_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "~> 5.0"

  role_name = var.role_name

  create_role = true
  role_requires_mfa = false

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]

  tags = var.tags
}

module "iam_instance_profile" {
  source = "terraform-aws-modules/iam/aws//modules/iam-instance-profile"
  version = "~> 5.0"

  instance_profile_name = var.instance_profile_name
  role_name = module.iam_role.iam_role_name

  tags = var.tags
}

data "aws_caller_identity" "current" {} 