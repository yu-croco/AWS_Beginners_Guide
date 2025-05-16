provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Env                = "dev"
      IsTerraformManaged = "true"
      System             = "infra-study-${var.owner}"
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
  # terraform init時に `-backend-config=backend.hcl`を指定する想定
  backend "s3" {}
}
