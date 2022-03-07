
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

resource "aws_cloudwatch_event_rule" "console" {
  name        = "capture-aws-sign-in"
  description = "Capture each AWS Console Sign In"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.console.name
  arn       = "arn:aws:lambda:ap-south-1:780467203909:function:function"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "function"
  principal     = "events.amazonaws.com"
}
