resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-strapi"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "CPU > 80% on ECS service"
  dimensions = {
    ClusterName = aws_ecs_cluster.strapi_cluster.name
    ServiceName = aws_ecs_service.strapi_service.name
  }
}

resource "aws_cloudwatch_metric_alarm" "high_memory" {
  alarm_name          = "high-memory-strapi"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Memory > 80% on ECS service"
  dimensions = {
    ClusterName = aws_ecs_cluster.strapi_cluster.name
    ServiceName = aws_ecs_service.strapi_service.name
  }
}

resource "aws_cloudwatch_metric_alarm" "unhealthy_tasks" {
  alarm_name          = "unhealthy-tasks-strapi"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 0
  alarm_description   = "ALB reports unhealthy targets"
  dimensions = {
    LoadBalancer = aws_lb.strapi_alb.dns_name
    TargetGroup  = aws_lb_target_group.strapi_tg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "high_latency" {
  alarm_name          = "high-latency-strapi"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "ALB latency > 1s"
  dimensions = {
    LoadBalancer = aws_lb.strapi_alb.dns_name
    TargetGroup  = aws_lb_target_group.strapi_tg.name
  }
}
