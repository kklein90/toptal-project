resource "cloudflare_ruleset" "static_assets_cache" {
  zone_id = var.cloudflare_zone_id
  name    = "Static asset caching"
  kind    = "zone"
  phase   = "http_request_cache_settings"

  rules {
    description = "Cache static assets for web/app domains"
    enabled     = true
    action      = "set_cache_settings"

    expression = "(http.host in {\"web.${var.public_domain}\" \"app.${var.public_domain}\" \"api.${var.public_domain}\"} and (ends_with(lower(http.request.uri.path), \".css\") or ends_with(lower(http.request.uri.path), \".js\") or ends_with(lower(http.request.uri.path), \".mjs\") or ends_with(lower(http.request.uri.path), \".map\") or ends_with(lower(http.request.uri.path), \".png\") or ends_with(lower(http.request.uri.path), \".jpg\") or ends_with(lower(http.request.uri.path), \".jpeg\") or ends_with(lower(http.request.uri.path), \".gif\") or ends_with(lower(http.request.uri.path), \".svg\") or ends_with(lower(http.request.uri.path), \".webp\") or ends_with(lower(http.request.uri.path), \".ico\") or ends_with(lower(http.request.uri.path), \".woff\") or ends_with(lower(http.request.uri.path), \".woff2\") or ends_with(lower(http.request.uri.path), \".ttf\") or ends_with(lower(http.request.uri.path), \".eot\")))"

    action_parameters {
      cache = true

      edge_ttl {
        mode    = "override_origin"
        default = 86400
      }

      browser_ttl {
        mode    = "override_origin"
        default = 14400
      }
    }
  }
}
