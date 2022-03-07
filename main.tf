terraform {
  provider "aws" {
    region = "us-west-2"
  }  
  cloud {
    organization = "hashicorpvenkat"
    workspaces {
      name = "TerraformCloud"
    }
  }
}
