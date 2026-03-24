output "Private_IP_Address" {
  value = aws_instance.Testing_Instance.private_ip       # Displays Private IP of Instance
}

output "Public_IP_Address" {
  value = aws_instance.Testing_Instance.public_ip        # Displays Public IP of Instance
}
