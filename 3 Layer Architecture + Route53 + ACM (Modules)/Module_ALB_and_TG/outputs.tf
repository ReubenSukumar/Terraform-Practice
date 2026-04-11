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
  description      = "Private ALB DNS Name"
  value            = aws_lb.T_private_ALB.dns_name               # Private-ALB DNS Name output required for main.tf in Module_EC2 for Nginx setup
}

output "public_alb_dns_r53" {
  description      = "Public ALB DNS Name"
  value            = aws_lb.T_public_ALB.dns_name                # Private-ALB DNS Name output required for main.tf in root  
}

output "public_alb_zone_r53" {
  description      = "Public ALB Zone ID"
  value            = aws_lb.T_public_ALB.zone_id                 # Private-ALB DNS Name output required for main.tf in root   
}