# resource "aws_cloudfront_cache_policy" "dynamic_no_cache" {
#   name        = "toptal-dynamic-no-cache"
#   comment     = "Disable edge caching for dynamic ECS application traffic"
#   default_ttl = 0
#   max_ttl     = 0
#   min_ttl     = 0

#   parameters_in_cache_key_and_forwarded_to_origin {
#     cookies_config {
#       cookie_behavior = "none"
#     }

#     headers_config {
#       header_behavior = "none"
#     }

#     query_strings_config {
#       query_string_behavior = "none"
#     }

#     enable_accept_encoding_brotli = false
#     enable_accept_encoding_gzip   = false
#   }
# }

# resource "aws_cloudfront_origin_request_policy" "dynamic_all_viewer" {
#   name    = "toptal-dynamic-all-viewer"
#   comment = "Forward all viewer request values to ALB origin for dynamic routing"

#   cookies_config {
#     cookie_behavior = "all"
#   }

#   headers_config {
#     header_behavior = "allViewer"
#   }

#   query_strings_config {
#     query_string_behavior = "all"
#   }
# }

# resource "aws_cloudfront_distribution" "toptal_distribution" {
#   enabled         = true
#   is_ipv6_enabled = true
#   comment         = "CloudFront distribution for ECS services behind ALB"
#   price_class     = "PriceClass_100"

#   origin {
#     domain_name = aws_lb.toptal_alb.dns_name
#     origin_id   = "toptal-alb-origin"

#     custom_origin_config {
#       http_port              = 80
#       https_port             = 443
#       origin_protocol_policy = "http-only"
#       origin_ssl_protocols   = ["TLSv1.2"]
#     }
#   }

#   default_cache_behavior {
#     target_origin_id       = "toptal-alb-origin"
#     viewer_protocol_policy = "redirect-to-https"
#     compress               = true

#     allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
#     cached_methods  = ["GET", "HEAD", "OPTIONS"]

#     cache_policy_id          = aws_cloudfront_cache_policy.dynamic_no_cache.id
#     origin_request_policy_id = aws_cloudfront_origin_request_policy.dynamic_all_viewer.id
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }

#   tags = {
#     Name         = "toptal-cloudfront"
#     "account"    = var.env
#     "owner"      = "techops"
#     "management" = "terraform"
#     "service"    = "infra"
#   }
# }
