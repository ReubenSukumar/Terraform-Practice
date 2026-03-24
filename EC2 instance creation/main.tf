provider "aws" {
  region = "us-east-1" # Mention the region where EC2 should be deployed
}

resource "aws_instance" "Trial-Instance" {
  ami             = "ami-0b6c6ebed2801a5cb"    # Caution: Use 'free tier eligible'
  instance_type   = "t3.micro"                 # Caution: Use 'free tier eligible'
  security_groups = ["sg-0e15788c55312345"]    # If Security Group is already created mention else remove this field 
  subnet_id       = "subnet-04bc3d5190e678945" # Mention the created subnet else remove this field
  tags = {
    Name = "Terraform-Test-Instance"           # Instance Name
  }
  key_name                    = "Test"         # .pem file name
  associate_public_ip_address = true           # Auto assign public IP is enabled
}

