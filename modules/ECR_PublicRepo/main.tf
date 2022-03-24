# provider "aws" {
#  alias = "us_east_1"
#  region = "us-east-1"
# }

# resource "aws_ecrpublic_repository" "public_repo" {
#  provider = aws.us_east_1
#  repository_name = "publicrepo"

# catalog_data {
#  about_text = "About_text"
#  architectures = ["ARM"]
#  description = "Description"
#  operating_systems = ["linux"]
#  usage_text = "Usage_Text"
# }
# }
