terraform {
  backend "s3" {
    bucket = "strapi-ec2-image"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}

resource "aws_ecs_cluster" "strapi_cluster" {
  name = "strapi-cluster"
}
