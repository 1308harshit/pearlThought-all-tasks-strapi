output "strapi_public_ip" {
  description = "Public IP of the deployed Strapi server"
  value       = aws_instance.strapi.public_ip
}