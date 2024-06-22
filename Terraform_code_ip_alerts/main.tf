# data "aws_vpc" "example" {
#   filter {
#     name   = "tag:Name"
#     values = ["${var.vpc_name}"]
#   }
# }

# output "vpc_name" {
#   value = data.aws_vpc.example.filter
# }

# data "aws_subnets" "subnet_value" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.example.id]
#   }
# }

# data "aws_subnet" "subnet_value" {
#   for_each = toset(data.aws_subnets.subnet_value.ids)
#   id       = each.value
# }

# output "subnet_cidr_blocks" {
#   value = [for s in data.aws_subnet.subnet_value : s.cidr_block]
# }


# resource "aws_cloudwatch_metric_alarm" "ip_usage_alarm" {
#   depends_on = [ aws_lambda_function.ip_usage_checker]
#   for_each            = toset(data.aws_subnets.subnet_value.ids)
#   alarm_name          = "IPUsageAlarm-${each.value}"
#   alarm_description   = "This alarm triggers when IP usage in the subnet exceeds the threshold"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = 1
#   metric_name         = "IPUsagePercentage"
#   namespace           = "SubnetIPUsage"
#   period              = 60
#   statistic           = "Maximum"
#   treat_missing_data  = "notBreaching"
#   threshold           = 0.6
#   actions_enabled     = true
#   ok_actions          = []
#   alarm_actions       = [aws_sns_topic.ip_usage_alert.arn]

#   dimensions = {
#     SubnetId  = each.key
#     CidrBlock = data.aws_subnet.subnet_value[each.value].cidr_block
#   }
# }



# # data "archive_file" "lambda_function_py" {
# #   type        = "zip"
# #   source_file = "./lambda_function.py"
# #   output_path = "./lambda_function.zip"
# # }

# # resource "aws_lambda_function" "ip_usage_checker" {
# #   filename         = data.archive_file.lambda_function_py.output_path
# #   function_name    = "ip-usage-checker"
# #   role             = aws_iam_role.lambda_execution_role.arn
# #   handler          = "lambda_function.lambda_handler"
# #   runtime          = "python3.8"
# #   source_code_hash = data.archive_file.lambda_function_py.output_base64sha256
# #   timeout          = 900

# #   environment {
# #     variables = {
# #       vpc_id          = data.aws_vpc.example.id
# #       sns_topic_name  = var.sns_topic_name
# #       event_rule_name = var.event_rule_name
# #       alert_email     = var.alert_email
# #       sns_topic_arn   = aws_sns_topic.ip_usage_alert.arn
# #     }
# #   }
# # }


# # data "archive_file" "lambda_function_py" {
# #   for_each    = { for idx, func in var.lambda_functions : idx => func }
# #   type        = "zip"
# #   source_file = each.value.source_file
# #   output_path = each.value.output_path
# # }

# # resource "aws_lambda_function" "ip_usage_checker" {
# #   for_each      = { for idx, func in var.lambda_functions : idx => func }
# #   # count = each.value.count ? 1 : 0

# #   filename         = data.archive_file.lambda_function_py[each.key].output_path
# #   function_name    = each.value.function_name
# #   role             = aws_iam_role.lambda_execution_role.arn
# #   handler          = each.value.handler
# #   runtime          = "python3.8"
# #   source_code_hash = data.archive_file.lambda_function_py[each.key].output_base64sha256

# #   environment {
# #     variables = {
# #       vpc_id          = data.aws_vpc.example.id
# #       sns_topic_arn   = aws_sns_topic.ip_usage_alert.arn
# #       event_rule_name = var.event_rule_name
# #       alert_email     = var.alert_email
# #   }
# # }
# # }

# # resource "aws_cloudwatch_log_group" "lambda_log_group" {
# #   for_each      = { for idx, func in var.lambda_functions : idx => func }
# #   name = "/aws/lambda/${each.value.function_name}"
# # }

resource "aws_sns_topic" "ip_usage_alert" {
  depends_on        = [aws_kms_key.example, aws_kms_alias.a]
  name              = var.sns_topic_name
  kms_master_key_id = aws_kms_alias.a.name
}

resource "aws_sns_topic_subscription" "subscription" {
  depends_on = [aws_sns_topic.ip_usage_alert]
  topic_arn  = aws_sns_topic.ip_usage_alert.arn
  protocol   = "email"
  endpoint   = var.alert_email
}

resource "aws_sns_topic_subscription" "opsgenie_subscription" {
  depends_on = [aws_sns_topic.ip_usage_alert]
  topic_arn  = aws_sns_topic.ip_usage_alert.arn
  protocol   = "https"
  endpoint   = var.opsgenie_url
}


# data "aws_iam_role" "existing_lambda_execution_role" {
#   name = "lambda-execution-role"
# }


# resource "aws_iam_role" "lambda_execution_role" {
#   count = var.create_iam_role && data.aws_iam_role.existing_lambda_execution_role.name == "" ? 1 : 0
#   name = "lambda-execution-role"
#   assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
# }

# resource "aws_iam_role_policy" "lambda_execution_policy" {
#   name   = "lambda-execution-policy"
#   role   = aws_iam_role.lambda_execution_role[count.index].id
#   policy = data.aws_iam_policy_document.lambda_execution_policy.json
# }

# resource "aws_iam_role_policy" "lambda_logs_policy" {
#   name   = "lambda-logs-policy"
#   role   = aws_iam_role.lambda_execution_role[count.index].id
#   policy = data.aws_iam_policy_document.lambda_logs_policy.json
# }

# resource "aws_iam_role_policy" "lambda_sns_policy" {
#   name   = "lambda-sns-policy"
#   role   = aws_iam_role.lambda_execution_role[count.index].id
#   policy = data.aws_iam_policy_document.lambda_sns_policy.json
# }

# resource "aws_iam_role_policy" "lambda_cloudwatch_alarms_policy" {
#   name   = "lambda-cloudwatch-alarms-policy"
#   role   = aws_iam_role.lambda_execution_role[count.index].id
#   policy = data.aws_iam_policy_document.lambda_cloudwatch_alarms_policy.json
# }

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "cloudwatch.amazonaws.com"]
    }
  }
}

# data "aws_iam_policy_document" "lambda_execution_policy" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "ec2:DescribeVpcs",
#       "ec2:DescribeSubnets",
#       "logs:CreateLogGroup",
#       "logs:CreateLogStream",
#       "cloudwatch:SetAlarmState",
#       "cloudwatch:PutMetricData",
#       "cloudwatch:PutMetricAlarm",
#       "cloudwatch:DescribeAlarms",
#       "events:PutRule",
#       "events:PutTargets"
#     ]
#     resources = ["*"]
#   }
# }

# data "aws_iam_policy_document" "lambda_logs_policy" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "logs:CreateLogGroup",
#       "logs:CreateLogStream",
#       "logs:PutLogEvents"
#     ]
#     resources = ["arn:aws:logs:*:*:*"]
#   }
# }

# data "aws_iam_policy_document" "lambda_sns_policy" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "sns:GetTopicAttributes",
#       "sns:CreateTopic",
#       "sns:Subscribe",
#       "sns:ListSubscriptionsByTopic",
#       "sns:Publish",
#       "kms:Generate*"
#     ]
#     resources = ["arn:aws:sns:*:*:*"]
#   }

#   statement {
#     effect = "Allow"
#     actions = [
#       "kms:GenerateDataKey",
#       "kms:Decrypt",
#       "kms:Encrypt",
#     ]
#     resources = ["*"]
#   }
# }

# data "aws_iam_policy_document" "lambda_cloudwatch_alarms_policy" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "cloudwatch:*"
#     ]
#     resources = ["arn:aws:cloudwatch:*:*:alarm:ip-usage-alarm-*"]
#   }
# }



resource "aws_kms_key" "example" {
  description = "subnet-ip-address"
}

resource "aws_kms_alias" "a" {
  name          = "alias/my-key-alias"
  target_key_id = aws_kms_key.example.key_id
}

# data "aws_iam_policy_document" "kms_key_policy" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "kms:*"
#     ]
#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::837140532212:root"]
#     }
#     resources = ["*"]
#   }

#   statement {
#     effect = "Allow"
#     actions = [
#       "kms:Decrypt",
#       "kms:GenerateDataKey"
#     ]
#     principals {
#       type        = "Service"
#       identifiers = ["cloudwatch.amazonaws.com"]
#     }
#     resources = ["*"]
#   }

#   statement {
#     effect = "Allow"
#     actions = [
#       "kms:Create*",
#       "kms:Describe*",
#       "kms:Enable*",
#       "kms:List*",
#       "kms:Put*",
#       "kms:Update*",
#       "kms:Revoke*",
#       "kms:Disable*",
#       "kms:Get*",
#       "kms:Delete*",
#       "kms:TagResource",
#       "kms:UntagResource",
#       "kms:ScheduleKeyDeletion",
#       "kms:CancelKeyDeletion",
#       "kms:GenerateDataKey",
#       "kms:Decrypt",
#       "kms:Encrypt"

#     ]
#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::837140532212:root"]
#     }
#     resources = ["*"]
#   }

# statement {
#     effect = "Allow"
#     actions = [
#       "kms:*"
#     ]
#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
#     }
#     resources = ["*"]
#   }



# }

# resource "aws_kms_key_policy" "key_policy" {
#   key_id = aws_kms_key.example.id
#   policy = data.aws_iam_policy_document.kms_key_policy.json
# }

# resource "aws_cloudwatch_event_rule" "example_rule" {
#   count       = length(var.lambda_functions)
#   name                = "Event"
#   description         = "Example EventBridge rule"
#   schedule_expression = "cron(*/2 * * * ? *)" # Example: Run everyday at 12:00 PM UTC
# }

# # resource "aws_cloudwatch_event_target" "example_target" {
# #   for_each      = { for idx, func in var.lambda_functions : idx => func }
# #   rule      = aws_cloudwatch_event_rule.example_rule.name
# #   target_id = "ip-usage-checker-${each.key}"
# #   arn       =  aws_lambda_function.ip_usage_checker[each.key].arn
# #   # arn = each.value.ar
# # }


# # output "aws_cloudwatch_event_target" {
# #   value = aws_cloudwatch_event_target.example_target
# # }

# # resource "aws_cloudwatch_metric_alarm" "ip_usage_alarm" {
# #   for_each            = toset(data.aws_subnets.subnet_value.ids)
# #   alarm_name          = "ip-usage-alarm-${each.value}"
# #   alarm_description   = "This alarm triggers when IP usage in the subnet exceeds the threshold"
# #   comparison_operator = "GreaterThanOrEqualToThreshold"
# #   evaluation_periods  = 1
# #   metric_name         = "IPUsagePercentage"
# #   namespace           = "SubnetIPUsage"
# #   period              = 30
# #   statistic           = "Minimum"
# #   threshold           = 0.1
# #   actions_enabled     = true
# #   treat_missing_data  = "notBreaching"
# #   alarm_actions = [aws_sns_topic.ip_usage_alert.arn]

# #   dimensions = {
# #     SubnetId  = each.key

# #     Percentage         = each.value.percentage 
# #     LambdaFunctionName = "ip-usage-checker"
# #   }

# # }




# locals {
#   create_lambda = length(var.lambda_functions) > 0 ? true : false
# }

# # 1. Update the `aws_lambda_function` resource to use `count` instead of `for_each`:

# # ```hcl
# resource "aws_lambda_function" "ip_usage_checker" {
#   count            = local.create_lambda ? length(var.lambda_functions) : 0
#   filename         = data.archive_file.lambda_function_py[count.index].output_path
#   function_name    = var.lambda_functions[count.index].function_name
#   role             = aws_iam_role.lambda_execution_role[count.index].arn
#   handler          = var.lambda_functions[count.index].handler
#   runtime          = "python3.8"
#   source_code_hash = data.archive_file.lambda_function_py[count.index].output_base64sha256
#   environment {
#     variables = {
#       vpc_id          = data.aws_vpc.example.id
#       sns_topic_arn   = aws_sns_topic.ip_usage_alert.arn
#       event_rule_name = var.event_rule_name
#       alert_email     = var.alert_email
#     }
#   }
# }
# # ```

# # 2. Update the `data "archive_file" "lambda_function_py"` block to use `count` based on the length of `var.lambda_functions`:

# # ```hcl
# data "archive_file" "lambda_function_py" {
#   count       = length(var.lambda_functions)
#   type        = "zip"
#   source_file = var.lambda_functions[count.index].source_file
#   output_path = var.lambda_functions[count.index].output_path
# }
# # ```

# # 3. Update the `aws_cloudwatch_log_group` resource to use `count` and reference the Lambda function name:

# # ```hcl
# resource "aws_cloudwatch_log_group" "lambda_log_group" {
#   count      = local.create_lambda ? length(var.lambda_functions) : 0
#   name       = "/aws/lambda/${aws_lambda_function.ip_usage_checker[count.index].function_name}"
#   depends_on = [aws_lambda_function.ip_usage_checker]
# }
# # ```

# # 4. Update the `aws_cloudwatch_event_target` resource to use `count` and reference the Lambda function ARN:


# resource "aws_cloudwatch_event_target" "ip_usage_checker_target" {
#   count      = local.create_lambda ? length(var.lambda_functions) : 0
#   rule       = aws_cloudwatch_event_rule.example_rule[count.index].name
#   target_id  = "ip_usage_checker_lambda_${count.index}"
#   arn        = aws_lambda_function.ip_usage_checker[count.index].arn
#   depends_on = [aws_lambda_function.ip_usage_checker, aws_cloudwatch_event_rule.example_rule]
# }
# # ```

# # 5. Update the `aws_lambda_permission` resource to use `count` and reference the Lambda function name and CloudWatch event rule ARN:

# # ```hcl
# resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
#   count         = local.create_lambda ? length(var.lambda_functions) : 0
#   statement_id  = "AllowExecutionFromCloudWatch_${count.index}"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.ip_usage_checker[count.index].function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.example_rule[count.index].arn
#   depends_on    = [aws_lambda_function.ip_usage_checker, aws_cloudwatch_event_rule.example_rule]
# }
# # ```






# module "kms" {
#   source = "terraform-aws-modules/kms/aws"

#   description = "subnet-ip-address"
#   key_usage   = "ENCRYPT_DECRYPT"



#   # Policy
#   key_owners                         = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
#   key_administrators                 = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
#   # key_service_roles_for_autoscaling  = ["arn:aws:iam::012345678901:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]

#   # Aliases
#   aliases = ["alias/my-key-alias"]

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }




# data "aws_iam_role" "existing_lambda_execution_role" {
#   name = "lambda-execution-role"
# }


# resource "aws_iam_role" "lambda_execution_role" {
#  count = can(data.aws_iam_role.existing_lambda_execution_role) == 0 ? 1 : 0
#   name = "lambda-execution-role"
#   assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json

#   #  lifecycle {
#   #   create_before_destroy = true
#   # }
# }


# data "aws_iam_role" "existing_lambda_execution_role" {
#   name = "lambda-execution-role"
# }

# resource "aws_iam_role" "lambda_execution_role" {
#   count = data.external.check_iam_role_exists.result ? 0 : 1
#   name               = "lambda-execution-role"
#   assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
# }

# resource "aws_iam_role_policy" "lambda_combined_policy" {
#   count  = local.create_iam_role ? 1 : 0
#   name   = "lambda-cloudwatch-alarms-policy"
#   role   = local.create_iam_role ? aws_iam_role.lambda_execution_role[0].id : data.aws_iam_role.existing_lambda_execution_role.id
#   policy = data.aws_iam_policy_document.lambda_combined_policy.json
# }

# resource "aws_lambda_function" "ip_usage_checker" {
#   # ...
#   role = local.create_iam_role ? aws_iam_role.lambda_execution_role[0].arn : data.aws_iam_role.existing_lambda_execution_role.arn
#   # ...
# }