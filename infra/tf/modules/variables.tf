variable "env" {}

variable "region" {}

variable "vpc-01-name" {}

variable "vpc-01-cidr" {}

variable "db-instance-type" {
  description = "Instance type for RDS"
  default     = "db.t4g.small"
}

variable "worker-instance-type" {
  description = "Instance type for workers"
  default     = "t3.micro"
}

variable "key-pair" {
  description = "Keypair"
  default     = "kk-040726"
}

