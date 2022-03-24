#module "roles" {
#  source = "./modules/roles"
#}

#module "sns" {
#  source = "./modules/sns"
#}

#module "kms_key" {
#  source = "./modules/kms_key"
#}

module "App_runner" {
 source = "./modules/App_runner"
}

module "ECR_PublicRepo" {
 source = "./modules/ECR_PublicRepo"
}

