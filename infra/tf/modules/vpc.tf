resource "aws_vpc" "vpc_01" {
  tags = {
    Name         = var.vpc-01-name
    "account"    = var.env
    "owner"      = "techops"
    "management" = "terraform"
    "service"    = "infra"
  }

  cidr_block           = var.vpc-01-cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
}

