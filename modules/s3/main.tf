# resource "aws_s3_bucket" "dockercontainer" { 
# 	bucket="dockercontainer2"
# 	#acl="public-read"
	
# 	tags = {
# 		Name = "DockerContainer2"
# 	}
# # 	lifecycle_rule {
# #             id = "log"
# # 	    enabled = true
# # 	expiration {
# # 	    days = 90
# # 	}
# # 	}
# }

resource "aws_s3_bucket_lifecycle_configuration" "example" {
  bucket = "dockercontainer2"
  rule {
    id = "rule-1"

    # ... other transition/expiration actions ...

    status = "Enabled"
    expiration {
      days = 90
    }
  }
}
