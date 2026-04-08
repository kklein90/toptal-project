resource "aws_ssm_parameter" "api_env" {
  name        = "/app/api"
  description = "api env"
  type        = "SecureString"
  value       = "0"

  tags = {
    owner      = "engineering"
    management = "terraform"
    service    = "api"
  }

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "web_env" {
  name        = "/app/web"
  description = "web env"
  type        = "SecureString"
  value       = "0"

  tags = {
    owner      = "engineering"
    management = "terraform"
    service    = "web"
  }

  lifecycle {
    ignore_changes = [value]
  }
}
