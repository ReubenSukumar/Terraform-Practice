###################################################                   VPC                  ################################################################
provider "aws" {
  region = "us-east-1"                                  # Region to be deployed
}

resource "aws_vpc" "vpc_T" {                            # Desired module name for VPC
  cidr_block       = var.CIDR                           # CIDR Block
  instance_tenancy = "default"

  tags = {
    Name = "Terraform-VPC"                              # Desired name for VPC
  }
}

resource "aws_internet_gateway" "vpc_T_gw" {            
  vpc_id = aws_vpc.vpc_T.id

  tags = {
    Name = "Terraform-IG"                               # Desired name for Internet Gateway
  }
}

resource "aws_subnet" "vpc_sub_public_1" {              
  vpc_id                  = aws_vpc.vpc_T.id
  cidr_block              = var.Public_Subnet_1
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"                # Define the AZ

  tags = {
    Name = "Terraform-Public-1a"                        # Desired name for subnet (Public Zone - 1)
  }
}

resource "aws_subnet" "vpc_sub_public_2" {              
  vpc_id                  = aws_vpc.vpc_T.id
  cidr_block              = var.Public_Subnet_2
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"                # Define the AZ

  tags = {
    Name = "Terraform-Public-1b"                        # Desired name for subnet (Public Zone - 2)
  }
}


resource "aws_route_table" "vpc_public_rt" {            
  vpc_id    = aws_vpc.vpc_T.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_T_gw.id 
  }

  tags = {
    Name = "Terraform-Public-RT"                         # Desired name for Route Table (Public)
  }
}

resource "aws_route_table_association" "vpc_public_1_rt" {              # Associate the Public Subnet 1a to Public Route Table
  subnet_id      = aws_subnet.vpc_sub_public_1.id
  route_table_id = aws_route_table.vpc_public_rt.id
}

resource "aws_route_table_association" "vpc_public_2_rt" {              # Associate the Public Subnet 1b to Public Route Table
  subnet_id      = aws_subnet.vpc_sub_public_2.id
  route_table_id = aws_route_table.vpc_public_rt.id
}

resource "aws_subnet" "vpc_sub_private_1" {                             
  vpc_id                  = aws_vpc.vpc_T.id
  cidr_block              = var.Private_Subnet_1
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"                                

  tags = {
    Name = "Terraform-Private-1a"                                       # Desired name for subnet (Private Zone - 1) 
  }
}

resource "aws_subnet" "vpc_sub_private_2" {                             
  vpc_id                  = aws_vpc.vpc_T.id
  cidr_block              = var.Private_Subnet_2
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"                          

  tags = {
    Name = "Terraform-Private-1b"                                       # Desired name for subnet (Private Zone - 2)
  }
}

resource "aws_route_table" "vpc_private_rt" {
  vpc_id = aws_vpc.vpc_T.id

  tags = {
    Name = "Terraform-Private-RT"                                       # Desired name for Route Table (Private)                    
  }
}

resource "aws_route" "for_private_NAT_instance" {
  route_table_id          = aws_route_table.vpc_private_rt.id           # Configure NAT instance for Private Route Table
  destination_cidr_block  = "0.0.0.0/0"
  network_interface_id    = var.Public_Interface_id
}

resource "aws_route_table_association" "vpc_sub_private_1_rt" {         # Associate the Private Subnet 1a to Private Route Table
  subnet_id      = aws_subnet.vpc_sub_private_1.id
  route_table_id = aws_route_table.vpc_private_rt.id
}

resource "aws_route_table_association" "vpc_sub_private_2_rt" {         # Associate the Private Subnet 1b to Private Route Table
  subnet_id      = aws_subnet.vpc_sub_private_2.id
  route_table_id = aws_route_table.vpc_private_rt.id
}


resource "aws_subnet" "vpc_sub_DB_private_1" {                             
  vpc_id                  = aws_vpc.vpc_T.id
  cidr_block              = var.Private_DB_Subnet_1
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"                                

  tags = {
    Name = "Terraform-DB-Private-1a"                                    # Desired name for subnet (DB Private Zone - 1) 
  }
}

resource "aws_subnet" "vpc_sub_DB_private_2" {                             
  vpc_id                  = aws_vpc.vpc_T.id
  cidr_block              = var.Private_DB_Subnet_2
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"                          

  tags = {
    Name = "Terraform-DB-Private-1b"                                    # Desired name for subnet (DB Private Zone - 2)
  }
}

resource "aws_route_table" "vpc_DB_private_rt" {
  vpc_id = aws_vpc.vpc_T.id

  tags = {
    Name = "Terraform-DB-Private-RT"                                    # Desired name for Route Table (Private)                    
  }
}

resource "aws_route" "pri_NAT_instance_to_DB" {
  route_table_id          = aws_route_table.vpc_DB_private_rt.id        # Configure NAT instance for Private Route Table
  destination_cidr_block  = "0.0.0.0/0"
  network_interface_id    = var.Public_Interface_id
}

resource "aws_route_table_association" "vpc_DB_sub_private_1_rt" {      # Associate the Private Subnet 1a to Private Route Table
  subnet_id      = aws_subnet.vpc_sub_DB_private_1.id
  route_table_id = aws_route_table.vpc_DB_private_rt.id
}

resource "aws_route_table_association" "vpc_DB_sub_private_2_rt" {      # Associate the Private Subnet 1b to Private Route Table
  subnet_id      = aws_subnet.vpc_sub_DB_private_2.id
  route_table_id = aws_route_table.vpc_DB_private_rt.id
}
