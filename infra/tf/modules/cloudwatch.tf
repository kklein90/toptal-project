resource "aws_cloudwatch_log_group" "web_loggroup" {
  name              = "web-app-logs-${var.region}-${var.env}"
  retention_in_days = 1
}


resource "aws_cloudwatch_log_group" "api_loggroup" {
  name              = "api-app-logs-${var.region}-${var.env}"
  retention_in_days = 1
}
