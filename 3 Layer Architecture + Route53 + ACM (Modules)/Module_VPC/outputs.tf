output "CIDR_Block" {
  value = aws_vpc.vpc_T.cidr_block                              # Display VPC CIDR block
}

output "public_subnet_ids"{
  description = "List of public subnet IDs"                     # Public Subnets output required for main.tf in Module_ALB_and_TG
  value = [
    aws_subnet.vpc_sub_public_1.id,
    aws_subnet.vpc_sub_public_2.id
  ]
}

output "private_subnet_ids"{
  description = "List of private subnet IDs"                    # Private Subnets output required for main.tf in Module_ALB_and_TG
  value = [
    aws_subnet.vpc_sub_private_1.id,
    aws_subnet.vpc_sub_private_2.id
  ]
}

output "id_vpc" {
  description = "VPC ID"                                        # VPC ID output required for main.tf in Module_Security_Group
  value = aws_vpc.vpc_T.id
}

output "Public_Subnet_1_ID" {                                   # Public Subnet-1 ID output required for main.tf in Module_EC2
  description = "Public Instance - 1 Subnet ID"
  value = aws_subnet.vpc_sub_public_1.id
}

output "Public_Subnet_2_ID" {
  description = "Public Instance - 2 Subnet ID"                 # Public Subnet-2 ID output required for main.tf in Module_EC2
  value = aws_subnet.vpc_sub_public_2.id
}

output "Private_Subnet_1_ID" {
  description = "Private Instance - 1 Subnet ID"                # Private Subnet-1 ID output required for main.tf in Module_EC2
  value = aws_subnet.vpc_sub_private_1.id
}

output "Private_Subnet_2_ID" {
  description = "Private Instance - 2 Subnet ID"                # Private Subnet-2 ID output required for main.tf in Module_EC2
  value = aws_subnet.vpc_sub_private_2.id
}

output "DB_Subnet_1_ID" {
  description = "Master Instance - 1 Subnet ID"                 # Private DB Subnet-1 ID output required for main.tf in Module_EC2
  value = aws_subnet.vpc_sub_DB_private_1.id
}

output "DB_Subnet_2_ID" {
  description = "Slave Instance - 2 Subnet ID"                  # Private DB Subnet-2 ID output required for main.tf in Module_EC2
  value = aws_subnet.vpc_sub_DB_private_2.id
}