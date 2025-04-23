variable "aws_region" {
  default = "us-east-1"
}

# aws is already configured in the environment
variable "aws_profile" {
  default = "default"
}

variable "key_name" {
    description = "Name of the SSH key pair"
    default     = "strapi-key"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "strapi_ami" {
  description = "Amazon Machine Image (AMI) for Ubuntu 22.04"
  default     = "ami-053b0d53c279acc90"  # Ubuntu 22.04 for us-east-1
}
