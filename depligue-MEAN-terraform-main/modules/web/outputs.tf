output "web_instance_ids" {
  value = aws_instance.web[*].id
}

output "web_private_ips" {
  value = aws_instance.web[*].private_ip
}

output "web_public_ips" {
  value = aws_instance.web[*].public_ip
}
