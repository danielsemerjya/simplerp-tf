terraform {
  backend "s3" {
    bucket         = "simplerp-tf"
    key            = "remote/s3/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "simplerp-tf-state-locking"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }
  required_version = "~> 1.0"
}

provider "aws" {
  region = "eu-central-1"
}

