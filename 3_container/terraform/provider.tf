provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Env                = "dev"
      IsTerraformManaged = "true"
      System             = "infra-study"
    }
  }
}

terraform {
  required_version = "= 1.0.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.60"
    }
  }
}
