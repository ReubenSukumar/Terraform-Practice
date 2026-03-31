provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc-T" {
  cidr_block       = "20.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Terraform-VPC"
  }
}

resource "aws_internet_gateway" "vpc-T-gw" {
  vpc_id = aws_vpc.vpc-T.id

  tags = {
    Name = "Terraform-IG"
  }
}

resource "aws_subnet" "vpc-sub-public-1" {
  vpc_id                  = aws_vpc.vpc-T.id
  cidr_block              = "20.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "Terraform-Public-1a"
  }
}

resource "aws_subnet" "vpc-sub-public-2" {
  vpc_id                  = aws_vpc.vpc-T.id
  cidr_block              = "20.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name = "Terraform-Public-1b"
  }
}


resource "aws_route_table" "vpc-public-rt" {
  vpc_id = aws_vpc.vpc-T.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-T-gw.id
  }

  tags = {
    Name = "Terraform-Public-RT"
  }
}

resource "aws_route_table_association" "vpc-public-1-rt" {
  subnet_id = aws_subnet.vpc-sub-public-1.id
  route_table_id = aws_route_table.vpc-public-rt.id
}

resource "aws_route_table_association" "vpc-public-2-rt" {
  subnet_id = aws_subnet.vpc-sub-public-2.id
  route_table_id = aws_route_table.vpc-public-rt.id
}

resource "aws_subnet" "vpc-sub-private-1" {
  vpc_id     = aws_vpc.vpc-T.id
  cidr_block = "20.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone = "us-east-1a"

  tags = {
    Name = "Terraform-Private-1a"
  }
}

resource "aws_subnet" "vpc-sub-private-2" {
  vpc_id     = aws_vpc.vpc-T.id
  cidr_block = "20.0.4.0/24"
  map_public_ip_on_launch = false
  availability_zone = "us-east-1b"

  tags = {
    Name = "Terraform-Private-1b"
  }
}

resource "aws_route_table" "vpc-private-rt" {
  vpc_id = aws_vpc.vpc-T.id

  tags = {
    Name = "Terraform-Private-RT"
  }
}

resource "aws_route_table_association" "vpc-sub-private-1-rt" {
  subnet_id = aws_subnet.vpc-sub-private-1.id
  route_table_id = aws_route_table.vpc-private-rt.id
}

resource "aws_route_table_association" "vpc-sub-private-2-rt" {
  subnet_id = aws_subnet.vpc-sub-private-2.id
  route_table_id = aws_route_table.vpc-private-rt.id
}