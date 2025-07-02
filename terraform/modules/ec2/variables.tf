variable "name" {
  description = "Name for the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for Ubuntu 22.04"
  type        = string
}

variable "instance_type" {
  description = "Instance type (e.g., t3.large)"
  type        = string
  default     = "t3.large"
}

variable "subnet_id" {
  description = "ID of the private subnet"
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name (for SSM)"
  type        = string
}

variable "user_data_path" {
  description = "Path to bootstrap.sh"
  type        = string
  default     = "${path.module}/../../scripts/bootstrap.sh"
}

variable "tags" {
  description = "Tags to apply to the EC2 instance"
  type        = map(string)
  default     = {}
}
