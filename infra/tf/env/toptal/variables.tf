variable "cloudflare_api_token" {
  description = "Cloudflare API token used by Terraform provider"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID for kwkc.xyz"
  type        = string
}
