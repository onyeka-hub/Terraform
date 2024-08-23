# for providers configurations
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region

  # for assuming a role
  assume_role {
    role_arn = "arn:aws:iam::938106001005:role/afxternpod_a_s3_dynamodb_access"
  }
}

# Configure S3 Backend
terraform {
  backend "s3" {}
}