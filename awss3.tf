resource "aws_s3_bucket" "dockercontainer" {
 bucket = "dockercontainer1"
 tags = {
   Name = "DockerContainer2"
 }
}

resource "aws_s3_bucket_acl" "dockercontainer_acl" {
 bucket = aws_s3_bucket.dockercontainer.id
 acl = "private"
}
