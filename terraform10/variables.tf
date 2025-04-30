variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "image_uri" {
  description = "The URI of the Docker image stored in ECR"
  type        = string
  default = "816069168735.dkr.ecr.us-east-1.amazonaws.com/strapi-app-image:latest"
}
