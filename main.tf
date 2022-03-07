terraform {
  required_providers {
    aws = {
      source = "registry.terraform.io/hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  
  cloud {
    organization = "hashicorpvenkat"
    
    workspaces {
      name = "TerraformCloud"
    }
  }
}
