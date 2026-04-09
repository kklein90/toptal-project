resource "aws_wafv2_web_acl" "waf_1" {
  name        = "waf-${var.env}-${var.region}"
  description = "WAF for the ${var.env} env in ${var.region} with basic rule set"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.region}-${var.env}-waf-1"
    sampled_requests_enabled   = true
  }

  tags = {
    Name      = "waf-${var.env}-${var.region}"
    owner     = "techops"
    managment = "terraform"
    region    = var.region
    service   = "security"
    usage     = "alb"
  }

  ### top rule group
  rule {
    name     = "RateLimitGroup"
    priority = 0

    override_action {
      none {}
    }

    statement {
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.rate_limit_rule_group.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitGroup"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AllowLocal"
    priority = 2

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.local_cidr.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AllowLocal"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "GeoMatchRule"
    priority = 3

    action {
      block {
        custom_response {
          response_code = 471

          response_header {
            name  = "ak-status"
            value = "bad-locale"
          }
        }
      }
    }

    statement {
      not_statement {
        statement {
          geo_match_statement {
            country_codes = [
              "CA",
              "US",
              "GB",
              "DE",
              "FR",
              "NL",
              "IE",
              "ES",
              "SE",
              "DK",
              "PL",
              "PT",
              "IT",
              "LT",
              "LV",
              "EE",
              "NO",
              "BE",
              "UA"
            ]
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "GeoMatchRule"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "BadPathsRuleGroup"
    priority = 4

    override_action {
      none {}
    }

    statement {
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.bad_paths_rule_group.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BadPathsRuleGroup"
      sampled_requests_enabled   = true
    }
  }

  ### end top rule group

  ### middle group
  rule {
    name     = "curl_match_rule"
    priority = 5

    statement {
      and_statement {
        statement {
          label_match_statement {
            key   = "awswaf:managed:aws:bot-control:signal:non_browser_user_agent"
            scope = "LABEL"
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "STARTS_WITH"
                search_string         = "curl"

                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 20
                  type     = "NONE"
                }
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "STARTS_WITH"
                search_string         = "python-requests"

                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 21
                  type     = "NONE"
                }
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "STARTS_WITH"
                search_string         = "PostmanRuntime"

                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 22
                  type     = "NONE"
                }
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "STARTS_WITH"
                search_string         = "okhttp"

                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 23
                  type     = "NONE"
                }
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "STARTS_WITH"
                search_string         = "Go-http-client"

                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 24
                  type     = "NONE"
                }
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "STARTS_WITH"
                search_string         = "ELB-HealthChecker"

                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 25
                  type     = "NONE"
                }
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "STARTS_WITH"
                search_string         = "AsterRC"

                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 26
                  type     = "NONE"
                }
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "STARTS_WITH"
                search_string         = "AsterKey"

                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 27
                  type     = "NONE"
                }
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "CONTAINS"
                search_string         = "UptimeRobot"

                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 28
                  type     = "NONE"
                }
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "CONTAINS"
                search_string         = "Datadog/Synthetics"

                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 29
                  type     = "NONE"
                }
              }
            }
          }
        }
      }
    }

    action {
      block {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "curl_match_rule"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 6

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        rule_action_override {
          action_to_use {
            count {}
          }

          name = "AWSManagedRulesCommonRuleSet"
        }

        rule_action_override {
          action_to_use {
            count {}
          }

          name = "NoUserAgent_HEADER"
        }

        rule_action_override {
          action_to_use {
            allow {}
          }

          name = "SizeRestrictions_BODY"
        }

        rule_action_override {
          action_to_use {
            count {}
          }

          name = "EC2MetaDataSSRF_BODY"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 7

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 8

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  ### end middle rule group

  ## bottom rule group
  rule {
    name     = "AWSManagedRulesBotControlRuleSet"
    priority = 9

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"

        managed_rule_group_configs {
          aws_managed_rules_bot_control_rule_set {
            inspection_level = "COMMON"
          }
        }

        rule_action_override {
          name = "CategoryMonitoring"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategorySeo"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategorySearchEngine"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "SignalNonBrowserUserAgent"

          action_to_use {
            count {
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesBotControlRuleSet"
      sampled_requests_enabled   = true
    }
  }
}



##### End WAF1 - External #####

#### WAF 2 - Internal ####
resource "aws_wafv2_web_acl" "waf_2_internal" {
  name        = "waf2-internal-${var.env}-${var.region}"
  description = "WAF for the ${var.env} env in ${var.region}"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.region}-${var.env}-waf-2"
    sampled_requests_enabled   = true
  }

  tags = {
    Name      = "waf2-internal-${var.env}-${var.region}"
    owner     = "techops"
    managment = "terraform"
    region    = var.region
    service   = "security"
    usage     = "alb"
  }

  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AllowLocal"
    priority = 2

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.local_cidr.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AllowLocal"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "GeoMatchRule"
    priority = 3

    action {
      block {
        custom_response {
          response_code = 471

          response_header {
            name  = "ak-status"
            value = "bad-locale"
          }
        }
      }
    }

    statement {
      not_statement {
        statement {
          geo_match_statement {
            country_codes = [
              "CA",
              "US",
              "GB",
              "DE",
              "FR",
              "NL",
              "IE",
              "ES",
              "SE",
              "DK",
              "PL",
              "PT",
              "IT",
              "LT",
              "LV",
              "EE",
              "NO",
              "BE",
              "UA"
            ]
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "GeoMatchRule"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "BadPathsRuleGroup"
    priority = 4

    override_action {
      none {}
    }

    statement {
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.bad_paths_rule_group.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BadPathsRuleGroup"
      sampled_requests_enabled   = true
    }
  }

  ### end top rule group

  ### middle group
  rule {
    name     = "curl_match_rule"
    priority = 5

    statement {
      and_statement {
        statement {
          label_match_statement {
            key   = "awswaf:managed:aws:bot-control:signal:non_browser_user_agent"
            scope = "LABEL"
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "STARTS_WITH"
                search_string         = "curl"

                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 20
                  type     = "NONE"
                }
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "STARTS_WITH"
                search_string         = "python-requests"

                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 21
                  type     = "NONE"
                }
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "STARTS_WITH"
                search_string         = "PostmanRuntime"

                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 22
                  type     = "NONE"
                }
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "STARTS_WITH"
                search_string         = "okhttp"

                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 23
                  type     = "NONE"
                }
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "STARTS_WITH"
                search_string         = "Go-http-client"

                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 24
                  type     = "NONE"
                }
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "STARTS_WITH"
                search_string         = "ELB-HealthChecker"

                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 25
                  type     = "NONE"
                }
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "STARTS_WITH"
                search_string         = "AsterRC"

                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 26
                  type     = "NONE"
                }
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "STARTS_WITH"
                search_string         = "AsterKey"

                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 27
                  type     = "NONE"
                }
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "CONTAINS"
                search_string         = "UptimeRobot"

                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 28
                  type     = "NONE"
                }
              }
            }
          }
        }
        statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "CONTAINS"
                search_string         = "Datadog/Synthetics"

                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }

                text_transformation {
                  priority = 29
                  type     = "NONE"
                }
              }
            }
          }
        }
      }
    }

    action {
      block {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "curl_match_rule"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 6

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        rule_action_override {
          action_to_use {
            count {}
          }

          name = "AWSManagedRulesCommonRuleSet"
        }

        rule_action_override {
          action_to_use {
            count {}
          }

          name = "NoUserAgent_HEADER"
        }

        rule_action_override {
          action_to_use {
            allow {}
          }

          name = "SizeRestrictions_BODY"
        }

        rule_action_override {
          action_to_use {
            count {}
          }

          name = "EC2MetaDataSSRF_BODY"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 7

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 8

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  ### end middle rule group

  ## bottom rule group
  rule {
    name     = "AWSManagedRulesBotControlRuleSet"
    priority = 9

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"

        managed_rule_group_configs {
          aws_managed_rules_bot_control_rule_set {
            inspection_level = "COMMON"
          }
        }

        rule_action_override {
          name = "CategoryMonitoring"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategorySeo"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategorySearchEngine"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "SignalNonBrowserUserAgent"

          action_to_use {
            count {
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesBotControlRuleSet"
      sampled_requests_enabled   = true
    }
  }
}
#### End WAF 2 internal ####

##### Rule Groups #####
resource "aws_wafv2_rule_group" "rate_limit_rule_group" {
  name     = "RateLimtGroup"
  scope    = "REGIONAL"
  capacity = 50

  rule {
    name     = "1minute"
    priority = 1
    action {
      block {
        custom_response {
          response_code = 531
        }
      }
    }
    statement {
      rate_based_statement {
        aggregate_key_type    = "IP"
        evaluation_window_sec = 60
        limit                 = 150
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "rate-limit-1min"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "2minute"
    priority = 2
    action {
      block {
        custom_response {
          response_code = 531
        }
      }
    }
    statement {
      rate_based_statement {
        aggregate_key_type    = "IP"
        evaluation_window_sec = 120
        limit                 = 175
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "rate-limit-2min"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "5minute"
    priority = 3
    action {
      block {
        custom_response {
          response_code = 531
        }
      }
    }
    statement {
      rate_based_statement {
        aggregate_key_type    = "IP"
        evaluation_window_sec = 300
        limit                 = 200
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "rate-limit-5min"
      sampled_requests_enabled   = true
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "rate-limit"
    sampled_requests_enabled   = true
  }

}

resource "aws_wafv2_rule_group" "bad_paths_rule_group" {
  name     = "BadPathsGroup"
  scope    = "REGIONAL"
  capacity = 100

  rule {
    name     = "paths1"
    priority = 1

    action {
      block {}
    }

    statement {
      or_statement {
        statement {
          byte_match_statement {
            positional_constraint = "STARTS_WITH"
            search_string         = "/script"

            field_to_match {
              uri_path {}
            }

            text_transformation {
              priority = 0
              type     = "LOWERCASE"
            }
          }
        }
        statement {
          byte_match_statement {
            positional_constraint = "STARTS_WITH"
            search_string         = "/info"

            field_to_match {
              uri_path {}
            }

            text_transformation {
              priority = 0
              type     = "LOWERCASE"
            }
          }
        }
        statement {
          byte_match_statement {
            positional_constraint = "STARTS_WITH"
            search_string         = "/password"

            field_to_match {
              uri_path {}
            }

            text_transformation {
              priority = 0
              type     = "LOWERCASE"
            }
          }
        }
        statement {
          byte_match_statement {
            positional_constraint = "STARTS_WITH"
            search_string         = "/system"

            field_to_match {
              uri_path {}
            }

            text_transformation {
              priority = 0
              type     = "LOWERCASE"
            }
          }
        }
        statement {
          byte_match_statement {
            positional_constraint = "STARTS_WITH"
            search_string         = "/files"

            field_to_match {
              uri_path {}
            }

            text_transformation {
              priority = 0
              type     = "LOWERCASE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "path-script-rule"
      sampled_requests_enabled   = false
    }

  }

  rule {
    name     = "paths2"
    priority = 2

    action {
      block {}
    }

    statement {
      or_statement {
        statement {
          byte_match_statement {
            positional_constraint = "STARTS_WITH"
            search_string         = "/bundle"

            field_to_match {
              uri_path {}
            }

            text_transformation {
              priority = 0
              type     = "LOWERCASE"
            }
          }
        }
        statement {
          byte_match_statement {
            positional_constraint = "STARTS_WITH"
            search_string         = "/1.php"

            field_to_match {
              uri_path {}
            }

            text_transformation {
              priority = 0
              type     = "LOWERCASE"
            }
          }
        }
        statement {
          byte_match_statement {
            positional_constraint = "STARTS_WITH"
            search_string         = "/geoip"

            field_to_match {
              uri_path {}
            }

            text_transformation {
              priority = 0
              type     = "LOWERCASE"
            }
          }
        }
        statement {
          byte_match_statement {
            positional_constraint = "STARTS_WITH"
            search_string         = "/form"

            field_to_match {
              uri_path {}
            }

            text_transformation {
              priority = 0
              type     = "LOWERCASE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "path-script-rule"
      sampled_requests_enabled   = false
    }

  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "bad-paths-group"
    sampled_requests_enabled   = true
  }

}
#### End Rule groups ####

##### logging configuration #####
## log groups ##
resource "aws_cloudwatch_log_group" "waf_1_loggroup" {
  name              = "aws-waf-logs-${var.region}-${var.env}"
  retention_in_days = var.env == "production" ? 14 : 1
}

resource "aws_cloudwatch_log_group" "waf_2_internal_loggroup" {
  name              = "aws-waf-logs-internal-logs-${var.region}-${var.env}"
  retention_in_days = var.env == "production" ? 14 : 1
}
## end log groups ##

## logging config for wafs ##
resource "aws_wafv2_web_acl_logging_configuration" "waf_1_log_conf" {
  log_destination_configs = [aws_cloudwatch_log_group.waf_1_loggroup.arn]
  resource_arn            = aws_wafv2_web_acl.waf_1.arn
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_2_internal_log_conf" {
  log_destination_configs = [aws_cloudwatch_log_group.waf_2_internal_loggroup.arn]
  resource_arn            = aws_wafv2_web_acl.waf_2_internal.arn
}
## end logging config for wafs ##

resource "aws_cloudwatch_log_resource_policy" "example" {
  policy_document = data.aws_iam_policy_document.waf_1_logging_policy.json
  policy_name     = "waf-1-webacl-logging-policy"
}

data "aws_iam_policy_document" "waf_1_logging_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.waf_1_loggroup.arn}:*"]
    condition {
      test     = "ArnLike"
      values   = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"]
      variable = "aws:SourceArn"
    }
    condition {
      test     = "StringEquals"
      values   = [tostring(data.aws_caller_identity.current.account_id)]
      variable = "aws:SourceAccount"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "example2" {
  policy_document = data.aws_iam_policy_document.waf_2_internal_logging_policy.json
  policy_name     = "waf-1-webacl-logging-policy"
}

data "aws_iam_policy_document" "waf_2_internal_logging_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.waf_2_internal_loggroup.arn}:*"]
    condition {
      test     = "ArnLike"
      values   = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"]
      variable = "aws:SourceArn"
    }
    condition {
      test     = "StringEquals"
      values   = [tostring(data.aws_caller_identity.current.account_id)]
      variable = "aws:SourceAccount"
    }
  }
}
## end logging policies ##

resource "aws_wafv2_ip_set" "local_cidr" {
  name               = "local-set"
  description        = "mylocalIPaddresses"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses = [
    aws_vpc.vpc_01.cidr_block
  ]
}

# ##### end logging configuration #####

resource "aws_wafv2_web_acl_association" "toptal_alb_waf_association" {
  resource_arn = aws_lb.toptal_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.waf_1.arn
}
