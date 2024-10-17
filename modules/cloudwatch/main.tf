resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  count               = length(var.instance_ids)
  alarm_name          = "High-CPU-Utilization-${element(var.instance_ids, count.index)}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 50
  alarm_description   = "This metric monitors CPU utilization"
  alarm_actions       = [] // No actions specified

  dimensions = {
    InstanceId = element(var.instance_ids, count.index)
  }
}