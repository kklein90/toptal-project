resource "aws_db_instance" "rds" {
  count                           = 1
  allocated_storage               = 20
  auto_minor_version_upgrade      = true
  backup_retention_period         = 7
  backup_window                   = "07:00-07:59"
  backup_target                   = "region"
  ca_cert_identifier              = "rds-ca-rsa2048-g1"
  copy_tags_to_snapshot           = true
  db_name                         = "toptal"
  db_subnet_group_name            = aws_db_subnet_group.rds_subnet_group.name
  delete_automated_backups        = true
  deletion_protection             = false
  enabled_cloudwatch_logs_exports = ["postgresql"]
  engine                          = "postgres"
  engine_version                  = "17"
  identifier                      = "toptal-db-${var.env}"
  instance_class                  = var.db-instance-type
  license_model                   = "postgresql-license"
  maintenance_window              = "wed:05:05-wed:06:05"
  max_allocated_storage           = 2048
  multi_az                        = false

  port                   = 5432
  skip_final_snapshot    = true
  storage_type           = "gp2"
  storage_encrypted      = true
  username               = "postgres"
  password               = random_password.db_password.result
  vpc_security_group_ids = [aws_security_group.rds_sec_group.id]
}


resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "subnet-group-01"
  subnet_ids = aws_subnet.private_data_subs_01[*].id

  tags = {
    management = "terraform"
    account    = "nonprod"
    owner      = "techops"
  }
}
