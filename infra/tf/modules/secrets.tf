resource "random_password" "db_password" {
  length  = 24
  special = false
}

resource "aws_secretsmanager_secret" "rds_secret_1" {
  name        = "/rds/cluster-a/secret1"
  description = "cluster-a rds secret"

  tags = {
    "owner"      = "techops"
    "management" = "terraform"
    "service"    = "infra"
  }
}
