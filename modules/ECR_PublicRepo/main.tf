provider "aws" {
  alias = "us_east_1"
  region = "us-east-1"
 }

 resource "aws_ecrpublic_repository" "publici_ecr_repo" {
  provider = aws.us_east_1
  repository_name = "public_ecr_repo"

 catalog_data {
  about_text = "About_text"
  architectures = ["ARM"]
  description = "Description"
  operating_systems = ["linux"]
  usage_text = "Usage_Text"
 }
}

resource "null_resource" "provisioner" {
 provisioner "local-exec" {
   command = "bash ecrrepo.sh"
}
}
