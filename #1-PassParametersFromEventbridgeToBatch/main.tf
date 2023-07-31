locals {
  project = "aws-shot-1"
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      env     = "dev"
      project = local.project
      owner   = var.owner
    }
  }
}

data "aws_caller_identity" "current" {}
