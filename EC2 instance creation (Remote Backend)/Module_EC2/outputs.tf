output "Private_IP_Address" {
  value = aws_instance.Testing_Instance.private_ip
}

output "Public_IP_Address" {
  value = aws_instance.Testing_Instance.public_ip
}
