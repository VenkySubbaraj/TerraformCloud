variable "kms_keys" {
  type = map(object({
    description = string
    policy_statements = list(object({
      actions   = list(string)
      resources = list(string)
      principals = list(object({
        type = string
        identifiers = list(string)
      }))
    }))
  }))

  default = {
    "my_kms_key_1" = {
      description = "KMS key for S3 access"
      policy_statements = [{
        actions   = ["kms:Encrypt", "kms:Decrypt"]
        resources = ["arn:aws:s3:::mybucket/*"]
        principals = [{
          type        = "AWS"
          identifiers = ["arn:aws:iam::123456789012:role/S3AccessRole"]
        }]
      }]
    },
    "my_kms_key_2" = {
      description = "KMS key for EC2 access"
      policy_statements = [{
        actions   = ["kms:Encrypt", "kms:Decrypt"]
        resources = ["arn:aws:ec2:::*"]
        principals = [{
          type        = "AWS"
          identifiers = ["arn:aws:iam::123456789012:role/EC2AccessRole"]
        }]
      }]
    }
  }
}



resource "aws_kms_key" "kms" {
  for_each = var.kms_keys

  description             = each.value.description
  deletion_window_in_days = 10
}


resource "aws_kms_key_policy" "kms_policy" {
  for_each = aws_kms_key.kms

  key_id = each.value.key_id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "kms-key-policy"
    Statement = [
      for statement in var.kms_keys[each.key].policy_statements : {
        Effect   = "Allow"
        Action   = statement.actions
        Resource = statement.resources
        Principal = {
          for principal in statement.principals : principal.type => principal.identifiers
        }
      }
    ]
  })
}
