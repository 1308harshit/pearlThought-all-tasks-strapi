variable "region" {
  default = "us-east-1"
}
variable "vpc_id" {
  default = "10.0.0.0/16"
}
      variable "public_subnets" { type = list(string) }
      variable "private_subnets" { type = list(string) }
      variable "execution_role_arn" {}
      variable "codedeploy_role_arn" {}

variable "image_uri" {
  description = "The URI of the Docker image stored in ECR"
  type        = string
  default = "816069168735.dkr.ecr.us-east-1.amazonaws.com/strapi-app-image:latest"
}
