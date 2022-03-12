
#resource "aws_s3_bucket" "dockercontainer" {
# bucket = var.s3_bucket_name
# tags = {
#   Name = var.tag_name
# }
#}

#resource "aws_s3_bucket_acl" "dockercontainer_acl" {
# bucket = aws_s3_bucket.dockercontainer.id
# acl = var.acl_value
#}

#resource "aws_cloudwatch_event_rule" "console" {
#  name        = "capture-aws-sign-in"
#  description = "Capture each AWS Console Sign In"
#  schedule_expression = "rate(5 minutes)"
#}

#resource "aws_cloudwatch_event_target" "sns" {
#  rule      = aws_cloudwatch_event_rule.console.name
#  arn       = "arn:aws:lambda:ap-south-1:780467203909:function:function"
#}

#resource "aws_lambda_permission" "allow_cloudwatch" {
#  statement_id  = "AllowExecutionsFromCloudWatch"
#  action        = "lambda:InvokeFunction"
#  function_name = "function"
#  principal     = "events.amazonaws.com"
#}

#resource "aws_lambda_function" "terraform_func" {
#filename                       = "python.zip"
#function_name                  = "terraformcode"
#role                           = "arn:aws:iam::780467203909:role/service-role/function-role-6fqhdy6g"
#handler                        = "lambda_handler"
#runtime                        = "python3.7"
#timeout                        = "180"
#vpc_config {
 #vpc_id = "vpc-0d71c7b0a4d763998"
# subnet_ids = ["subnet-0e1db0fecd9cd4a8a"]
# security_group_ids = ["sg-0de8512432df6e091"]
#}
#}


resource "aws_iam_role" "test_role" {
  name = "s3_roles"
  assume_role_policy = file("${path.module}/policies/role.json")
}
