output "db_private_ip" {
  description = "Dirección IP privada de la instancia de MongoDB"
  value       = aws_instance.mongodb.private_ip
}
