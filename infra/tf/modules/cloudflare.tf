resource "cloudflare_record" "api" {
  zone_id = var.cloudflare_zone_id
  name    = "api"
  type    = "CNAME"
  value   = aws_lb.toptal_alb.dns_name
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "web" {
  zone_id = var.cloudflare_zone_id
  name    = "web"
  type    = "CNAME"
  value   = aws_lb.toptal_alb.dns_name
  ttl     = 1
  proxied = false
}
