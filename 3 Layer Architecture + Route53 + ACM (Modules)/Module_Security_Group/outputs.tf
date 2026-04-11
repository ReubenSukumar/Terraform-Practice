output "Public_Instance_1_SG" {
  description = "Public Instance - 1 Security Group"                            # Public Instance SG ID variable required for main.tf in Module_EC2
  value = aws_security_group.T_Public_SG.id
}

output "Private_Instance_1_SG" {
  description = "Private Instance - 1 Security Group"                           # Private Instance SG ID variable required for main.tf in Module_EC2
  value = aws_security_group.T_Private_SG.id
}

output "Master_DB_SG" {
  description = "Master Server Security Group"                                  # Master DB Instance SG ID variable required for main.tf in Module_EC2
  value = aws_security_group.T_Master_DB_SG.id
}

output "Slave_DB_SG" {
  description = "Slave Server Security Group"                                   # Slave DB Instance SG ID variable required for main.tf in Module_EC2
  value = aws_security_group.T_Slave_DB_SG.id
}

output "public_alb_security_group" {
  description = "Security Group for Public ALB"                                 # Public ALB SG ID variable required for main.tf in Module_ALB_and_TG
  value = aws_security_group.T_ALB_public_SG.id
}

output "private_alb_security_group" {
  description = "Security Group for Public ALB"                                 # Public ALB SG ID variable required for main.tf in Module_ALB_and_TG
  value = aws_security_group.T_ALB_private_SG.id
}