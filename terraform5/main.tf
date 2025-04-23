terraform {
  backend "s3" {
    bucket = "strapi-ec2-image"
    key = "terrafrom/terrafrom.tfstate"
    region = "us-east-1"
  }
}
provider "aws" {
  region = var.region
}