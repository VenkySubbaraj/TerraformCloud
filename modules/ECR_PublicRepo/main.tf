provider "aws" {
 alias = "us_west_2"
 region = "us-west-2"
}

resource "aws_ecrpublic_repository" "public_repo" {
 provider = aws.us_west_2
 repository_name = "publicrepo"

catalog_data {
 about_text = "About_text"
 architectures = ["ARM"]
 description = "Description"
 operating_systems = ["linux"]
 usage_text = "Usage_Text"
}
}
