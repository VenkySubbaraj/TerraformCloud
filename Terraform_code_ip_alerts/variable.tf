# variable "vpc_id" {
#   description = "The VPC ID in which the Lambda function will be deployed"
#   type        = string
#   default     = "vpc-008c6f4cf6fd3583f"
# }

variable "alert_email" {
  description = "Email address to receive IP usage alerts"
  type        = string
  default     = "venkatachalapathys1996@gmail.com"
}

# variable "aws_region" {
#   description = "AWS region to deploy resources"
#   type        = string
#   default     = "ap-south-1"
# }

variable "sns_topic_name" {
  description = "Name of the SNS topic for IP usage alerts"
  type        = string
  default     = "ip-usage-alerts"
}

# variable "vpc_name" {
#   description = "Name of the vpc connections"
#   type        = string
#   default     = "default"
# }

# variable "event_rule_name" {
#   description = "Name of the EventBridge rule"
#   type        = string
#   default     = "ip-usage-checker-rule"
# }


# # variable "lambda_functions" {
# #   type = list(object({
# #     source_file   = string
# #     output_path   = string
# #     function_name = string
# #     handler       = string
# #   }))
# # }



# # 6. Define the `var.lambda_functions` variable as a list of objects in your Terraform configuration:


# variable "lambda_functions" {
#   type = list(object({
#     source_file   = string
#     output_path   = string
#     function_name = string
#     handler       = string
#   }))

#   default = [
#     {
#       source_file   = "./lambda_function1.py"
#       output_path   = "./lambda_function1.zip"
#       function_name = "ip-usage-checker-1"
#       handler       = "lambda_function1.lambda_handler"
#     },
#     {
#       source_file   = "./lambda_function2.py"
#       output_path   = "./lambda_function2.zip"
#       function_name = "ip-usage-checker-2"
#       handler       = "lambda_function2.lambda_handler"
#     }
#   ]
# }



# variable "create_iam_role" {
#   description = "Determines whether to create the IAM role or not"
#   default     = 1  # Set the default value based on your requirements
# }

# variable "opsgenie_url" {
#     type = string
#     default = "https://api.opsgenie.com/v1/json/cloudwatch?apiKey=1be64281-de6d-4437-8488-2d10780d9b84"
# }