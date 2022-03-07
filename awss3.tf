
resource "aws_s3_bucket" "dockercontainer" {
 bucket = var.s3_bucket_name
 tags = {
   Name = var.tag_name
 }
}

resource "aws_s3_bucket_acl" "dockercontainer_acl" {
 bucket = aws_s3_bucket.dockercontainer.id
 acl = var.acl_value
}
