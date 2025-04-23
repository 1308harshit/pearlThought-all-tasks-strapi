resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "strapi_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content              = tls_private_key.ssh_key.private_key_pem
  filename             = "${path.module}/${var.key_name}.pem"
  file_permission      = "0400"
}

resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg"
  description = "Allow HTTP, HTTPS, and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "strapi" {
  ami           = var.strapi_ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.strapi_key.key_name
  security_groups = [aws_security_group.strapi_sg.name]
  
  user_data = file("${path.module}/strapi-setup.sh")
  
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name    = "strapi-instance"
    Owner   = "Harshit"
    Protect = "true"
  }
}

