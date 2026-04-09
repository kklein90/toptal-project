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

variable "dockerhub-username" {
  description = "Docker Hub username used to pull web/api images"
  default     = "kklein90"
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID used for public DNS records"
  type        = string
}

variable "public_domain" {
  description = "Public domain name managed in Cloudflare"
  type        = string
}
