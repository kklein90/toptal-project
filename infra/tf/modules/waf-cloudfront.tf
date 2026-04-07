# resource "aws_wafv2_web_acl" "waf_2" {
#   name        = "waf-cloudfront-${var.env}-${var.region}"
#   description = "WAF for the cloudfront-${var.env} env in ${var.region}"
#   scope       = "CLOUDFRONT"

#   default_action {
#     allow {}
#   }

#   visibility_config {
#     cloudwatch_metrics_enabled = true
#     metric_name                = "${var.region}-${var.env}-waf-1"
#     sampled_requests_enabled   = true
#   }

#   tags = {
#     Name      = "waf-cloudfront-${var.env}-${var.region}"
#     owner     = "techops"
#     managment = "terraform"
#     region    = var.region
#     service   = "security"
#     usage     = "cloudfront"
#   }

#   rule {
#     name     = "AWS-AWSManagedRulesCommonRuleSet"
#     priority = 1

#     override_action {
#       none {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesCommonRuleSet"
#         vendor_name = "AWS"

#         rule_action_override {
#           action_to_use {
#             count {}
#           }

#           name = "AWSManagedRulesCommonRuleSet"
#         }

#         rule_action_override {
#           action_to_use {
#             count {}
#           }

#           name = "NoUserAgent_HEADER"
#         }
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
#       sampled_requests_enabled   = true
#     }
#   }

#   rule {
#     name     = "AWS-AWSManagedRulesAmazonIpReputationList"
#     priority = 2

#     override_action {
#       none {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesAmazonIpReputationList"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesAmazonIpReputationList"
#       sampled_requests_enabled   = true
#     }
#   }

#   rule {
#     name     = "AWS-AWSManagedRulesSQLiRuleSet"
#     priority = 3

#     override_action {
#       none {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesSQLiRuleSet"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWS-AWSManagedRulesSQLiRuleSet"
#       sampled_requests_enabled   = true
#     }
#   }

#   rule {
#     name     = "AWSManagedRulesKnownBadInputsRuleSet"
#     priority = 4

#     override_action {
#       none {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesKnownBadInputsRuleSet"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesKnownBadInputsRuleSet"
#       sampled_requests_enabled   = true
#     }
#   }

#   rule {
#     name     = "AWSManagedRulesBotControlRuleSet"
#     priority = 5

#     override_action {
#       count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesBotControlRuleSet"
#         vendor_name = "AWS"

#         managed_rule_group_configs {
#           aws_managed_rules_bot_control_rule_set {
#             inspection_level = "COMMON"
#           }
#         }

#         rule_action_override {
#           name = "CategoryMonitoring"

#           action_to_use {
#             count {
#             }
#           }
#         }
#         rule_action_override {
#           name = "CategorySeo"

#           action_to_use {
#             count {
#             }
#           }
#         }
#         rule_action_override {
#           name = "CategorySearchEngine"

#           action_to_use {
#             count {
#             }
#           }
#         }
#         rule_action_override {
#           name = "SignalNonBrowserUserAgent"

#           action_to_use {
#             count {
#             }
#           }
#         }
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesBotControlRuleSet"
#       sampled_requests_enabled   = true
#     }
#   }

#   rule {
#     name     = "curl_match_rule"
#     priority = 6

#     statement {
#       and_statement {
#         statement {
#           label_match_statement {
#             key   = "awswaf:managed:aws:bot-control:signal:non_browser_user_agent"
#             scope = "LABEL"
#           }
#         }
#         statement {
#           not_statement {
#             statement {
#               byte_match_statement {
#                 positional_constraint = "STARTS_WITH"
#                 search_string         = "curl"

#                 field_to_match {
#                   single_header {
#                     name = "user-agent"
#                   }
#                 }

#                 text_transformation {
#                   priority = 20
#                   type     = "NONE"
#                 }
#               }
#             }
#           }
#         }
#         statement {
#           not_statement {
#             statement {
#               byte_match_statement {
#                 positional_constraint = "STARTS_WITH"
#                 search_string         = "python-requests"

#                 field_to_match {
#                   single_header {
#                     name = "user-agent"
#                   }
#                 }

#                 text_transformation {
#                   priority = 21
#                   type     = "NONE"
#                 }
#               }
#             }
#           }
#         }
#       }
#     }

#     action {
#       block {}
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "curl_match_rule"
#       sampled_requests_enabled   = true
#     }
#   }
# }

# #### association to other resources should be configured in those resource's repo
# # resource "aws_wafv2_web_acl_association" "waf_2_alb_association" {
# #   resource_arn = var.alb1-arn
# #   web_acl_arn  = aws_wafv2_web_acl.waf_2.arn
# # }

# ### this will only be needed in accounts with multiple ALB's
# # resource "aws_wafv2_web_acl_association" "waf_2_alb_association_2" {
# #   depends_on   = [aws_wafv2_web_acl.waf_2]
# #   resource_arn = var.alb2-arn
# #   web_acl_arn  = aws_wafv2_web_acl.waf_2.arn
# # }

# ##### logging configuration #####
# resource "aws_cloudwatch_log_group" "waf_2_loggroup" {
#   name              = "aws-waf-cloudfront-logs-${var.region}-${var.env}"
#   retention_in_days = var.env == "production" ? 14 : 1
# }

# resource "aws_cloudwatch_log_resource_policy" "waf_2_resource_policy" {
#   policy_document = data.aws_iam_policy_document.waf_2_logging_policy.json
#   policy_name     = "waf-2-webacl-logging-policy"
# }

# ## this is broken
# # resource "aws_wafv2_web_acl_logging_configuration" "waf_2_log_conf" {
# #   log_destination_configs = [aws_cloudwatch_log_group.waf_2_loggroup.arn]
# #   resource_arn            = aws_wafv2_web_acl.waf_2.arn
# # }

# data "aws_iam_policy_document" "waf_2_logging_policy" {
#   version = "2012-10-17"
#   statement {
#     effect = "Allow"
#     principals {
#       identifiers = ["delivery.logs.amazonaws.com"]
#       type        = "Service"
#     }
#     actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
#     resources = ["${aws_cloudwatch_log_group.waf_2_loggroup.arn}:*"]
#     condition {
#       test     = "ArnLike"
#       values   = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"]
#       variable = "aws:SourceArn"
#     }
#     condition {
#       test     = "StringEquals"
#       values   = [tostring(data.aws_caller_identity.current.account_id)]
#       variable = "aws:SourceAccount"
#     }
#   }
# }

# ##### end logging configuration ####
