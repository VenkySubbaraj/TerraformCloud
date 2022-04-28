resource "aws_s3_bucket" "dockercontainer" { 
	bucket="dockercontainer2"
	acl="public-read"
	
	tags = {
		Name = "DockerContainer2"
	}
	lifecycle_rule {
            id = "log"
	    enabled = true
	expiration {
	    days = 90
	}
	}
}