resource "aws_ecrpublic_repository" "public_repo" {
 repository_name = "publicrepo"

catalog_data {
 about_text = "About_text"
 architectures = ["ARM"]
 description = "Description"
 operating_systems = ["linux"]
 usage_text = "Usage_Text"
}
}
