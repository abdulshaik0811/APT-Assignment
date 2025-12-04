resource "aws_cloudwatch_log_group" "app_logs" {
  name = "/oneclick/app"
  retention_in_days = 14
  tags = { Name = "oneclick-app-logs" }
}
