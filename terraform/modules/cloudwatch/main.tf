# CloudWatch Agent configuration
resource "aws_cloudwatch_log_group" "application" {
  name              = "/aws/ec2/${var.instance_name}"
  retention_in_days = 14

  tags = var.tags
}

# CloudWatch Agent configuration document
resource "aws_ssm_parameter" "cloudwatch_agent_config" {
  name  = "/cloudwatch-agent/config"
  type  = "String"
  value = jsonencode({
    logs = {
      logs_collected = {
        files = {
          collect_list = [
            {
              file_path = "/var/log/docker/*.log"
              log_group_name = "/aws/ec2/${var.instance_name}/docker"
              log_stream_name = "{instance_id}"
              timezone = "UTC"
            },
            {
              file_path = "/var/log/syslog"
              log_group_name = "/aws/ec2/${var.instance_name}/syslog"
              log_stream_name = "{instance_id}"
              timezone = "UTC"
            }
          ]
        }
      }
    }
    metrics = {
      metrics_collected = {
        cpu = {
          measurement = ["cpu_usage_idle", "cpu_usage_iowait", "cpu_usage_user", "cpu_usage_system"]
          metrics_collection_interval = 60
          resources = ["*"]
        }
        disk = {
          measurement = ["used_percent"]
          metrics_collection_interval = 60
          resources = ["*"]
        }
        mem = {
          measurement = ["mem_used_percent"]
          metrics_collection_interval = 60
        }
      }
    }
  })

  tags = var.tags
}

# CloudWatch Alarms
module "cloudwatch_alarms" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"

  for_each = var.alarms

  alarm_name          = each.value.name
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  alarm_description   = each.value.description
  alarm_actions       = each.value.alarm_actions
  ok_actions          = each.value.ok_actions

  dimensions = {
    InstanceId = var.instance_id
  }

  tags = var.tags
}
