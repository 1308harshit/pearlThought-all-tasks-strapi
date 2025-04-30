terraform {
  backend "s3" {
    bucket = "strapi-ec2-image"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

# data "aws_caller_identity" "current" {}