module "roles" {
  source = "./modules/roles"
}

module "sns" {
  source = "./modules/sns"
}

module "kms_alias" {
  source = "./modules/kms_alias"
}
