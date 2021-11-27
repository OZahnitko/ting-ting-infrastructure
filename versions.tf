terraform {
  backend "remote" {
    organization = "ozahnitko"

    workspaces {
      name = "ting-ting-infrastructure"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
