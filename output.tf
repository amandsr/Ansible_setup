output "control_node_public_ip" {
  description = "Webserver's public IP"
  value       = aws_instance.server[0].public_ip
}

output "client1_public_ip" {
  description = "Webserver's public IP"
  value       = aws_instance.server[1].public_ip
}

output "client2_public_ip" {
  description = "Webserver's public IP"
  value       = aws_instance.server[2].public_ip
}