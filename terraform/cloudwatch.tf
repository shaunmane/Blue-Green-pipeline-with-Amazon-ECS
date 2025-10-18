# Log Group where taskdef is configured to send all logs
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = "tripmgmt-demo-ecstask-loggrp"

  retention_in_days = 5

  tags = {
    Environment = "dev"
    Application = "tripmgmt-demo"
  }
}
