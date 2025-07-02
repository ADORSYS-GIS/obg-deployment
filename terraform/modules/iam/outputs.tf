output "role_name" {
  description = "Name of the IAM role"
  value       = module.iam_role.iam_role_name
}

output "role_arn" {
  description = "ARN of the IAM role"
  value       = module.iam_role.iam_role_arn
}

output "instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = module.iam_instance_profile.iam_instance_profile_name
}

output "instance_profile_arn" {
  description = "ARN of the IAM instance profile"
  value       = module.iam_instance_profile.iam_instance_profile_arn
} 