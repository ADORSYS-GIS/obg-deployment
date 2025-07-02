output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.application.name
}

output "log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.application.arn
}

output "cloudwatch_agent_config_parameter" {
  description = "SSM parameter name for CloudWatch agent configuration"
  value       = aws_ssm_parameter.cloudwatch_agent_config.name
}

output "alarm_names" {
  description = "Names of the created CloudWatch alarms"
  value       = [for alarm in module.cloudwatch_alarms : alarm.cloudwatch_metric_alarm_id]
}
