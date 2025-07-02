output "security_group_id" {
  description = "ID of the security group"
  value       = module.security_group.security_group_id
}

output "security_group_arn" {
  description = "ARN of the security group"
  value       = module.security_group.security_group_arn
} 