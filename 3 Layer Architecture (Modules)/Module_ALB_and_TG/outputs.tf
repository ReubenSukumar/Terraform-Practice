output "ALB_Name" {
  value = {
    "External_ALB" = {
        Public_ALB = aws_lb.T_public_ALB.name                    # Display ALB Names
    }

    "Internal_ALB" = {
        Private_ALB = aws_lb.T_private_ALB.name
    }
}
}

output "private_alb_script" {
  description = "Public ALB DNS Name"
  value = aws_lb.T_private_ALB.dns_name                         # Private-ALB DNS Name output required for main.tf in root
}
