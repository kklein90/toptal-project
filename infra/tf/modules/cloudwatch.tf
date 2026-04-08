resource "aws_cloudwatch_log_group" "web_loggroup" {
  name              = "/toptal/web"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_stream" "web_stream" {
  name           = "web"
  log_group_name = aws_cloudwatch_log_group.web_loggroup.name
}

resource "aws_cloudwatch_log_group" "api_loggroup" {
  name              = "/toptal/api"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_stream" "api_stream" {
  name           = "api"
  log_group_name = aws_cloudwatch_log_group.api_loggroup.name
}
