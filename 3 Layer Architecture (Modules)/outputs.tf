output "VPC_block"{
    value = module.vpc.CIDR_Block
}

output "Public_Instance_Names" {
  value = module.ec2.Public_Instance_Name
}

output "Public_IPs" {
  value = module.ec2.Public_Instance_IPs
}

output "Private_Instance_Names" {
  value = module.ec2.Private_Instance_Name
}

output "Private_IPs" {
  value = module.ec2.Private_Instance_IPs
}

output "ALB_Names" {
  value = module.alb.ALB_Name
}