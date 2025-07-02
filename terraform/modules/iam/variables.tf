variable "role_name" {
  description = "Name for the IAM role"
  type        = string
}

variable "instance_profile_name" {
  description = "Name for the IAM instance profile"
  type        = string
}

variable "tags" {
  description = "Tags to apply to IAM resources"
  type        = map(string)
  default     = {}
} 