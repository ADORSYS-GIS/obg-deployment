variable "instance_id" {
  description = "EC2 instance ID for monitoring"
  type        = string
}

variable "instance_name" {
  description = "Name of the EC2 instance for log groups"
  type        = string
}

variable "alarms" {
  description = "Map of CloudWatch alarms to create"
  type = map(object({
    name                = string
    comparison_operator = string
    evaluation_periods  = number
    metric_name         = string
    namespace           = string
    period              = number
    statistic           = string
    threshold           = number
    description         = string
    alarm_actions       = list(string)
    ok_actions          = list(string)
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to CloudWatch resources"
  type        = map(string)
  default     = {}
}
