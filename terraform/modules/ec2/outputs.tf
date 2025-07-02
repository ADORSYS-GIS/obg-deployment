output "instance_id" {
  value       = module.ec2_instance.id
  description = "EC2 instance ID"
}

output "private_ip" {
  value       = module.ec2_instance.private_ip
  description = "Private IP address"
}

output "arn" {
  value       = module.ec2_instance.arn
  description = "EC2 instance ARN"
}

