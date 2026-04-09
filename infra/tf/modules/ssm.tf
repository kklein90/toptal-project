resource "aws_ssm_parameter" "api_env_db" {
  name        = "/app/api/db"
  description = "api env"
  type        = "SecureString"
  value       = aws_db_instance.rds[0].db_name

  tags = {
    owner      = "engineering"
    management = "terraform"
    service    = "api"
  }

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "api_env_dbuser" {
  name        = "/app/api/dbuser"
  description = "api env"
  type        = "SecureString"
  value       = aws_db_instance.rds[0].username

  tags = {
    owner      = "engineering"
    management = "terraform"
    service    = "api"
  }

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "api_env_dbpass" {
  name        = "/app/api/dbpass"
  description = "api env"
  type        = "SecureString"
  value       = random_password.db_password.result

  tags = {
    owner      = "engineering"
    management = "terraform"
    service    = "api"
  }

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "api_env_dbhost" {
  name        = "/app/api/dbhost"
  description = "api env"
  type        = "SecureString"
  value       = "${aws_service_discovery_service.db.name}.${aws_service_discovery_private_dns_namespace.asterkey_local_ecs_namespace.name}"

  tags = {
    owner      = "engineering"
    management = "terraform"
    service    = "api"
  }

  lifecycle {
    ignore_changes = [value]
  }
}


