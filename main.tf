terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  
  cloud {
    organization = "hashicorpvenkat"
    
    workspace {
      name = "gh-actions-demo"
    }
  }
}
