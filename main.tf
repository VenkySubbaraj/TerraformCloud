#module "roles" {
#  source = "./modules/roles"
#}

#module "sns" {
#  source = "./modules/sns"
#}

#module "kms_key" {
#  source = "./modules/kms_key"
#}


# module "App_runner" {
#  source = "./modules/App_runner"
# }

# module "s3" {
#  source = "./modules/s3"
# }

module "terraform_read" {
    source = "./modules/terraform_read"
    pg_extensions = var.pg_extensions
}
 
#module "ECR_PublicRepo" {
# source = "./modules/ECR_PublicRepo"
#}
