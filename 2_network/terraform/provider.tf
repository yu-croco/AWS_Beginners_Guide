provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Env                = "dev"
      IsTerraformManaged = "true"
      System             = "infra-study"
      Owner              = var.owner
    }
  }
}

terraform {
  required_version = "~> 1.10.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.35.0"
    }
  }
}
