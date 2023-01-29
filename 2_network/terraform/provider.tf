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
  required_version = "= 1.3.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.52.0"
    }
  }
}
