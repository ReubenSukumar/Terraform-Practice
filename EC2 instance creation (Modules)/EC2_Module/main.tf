provider "aws" {
  region = "us-east-1"                                 # Mention the region where EC2 should be deployed
}

resource "aws_instance" "Trial_Instance" {
  ami             = "ami-0b6c6ebed2801a5cb"            # Caution: Use 'free tier eligible'
  instance_type   = "t3.micro"                         # Caution: Use 'free tier eligible'
  security_groups = ["sg-0e15788c553321987"]           # If Security Group is already created mention else remove this field 
  subnet_id       = "subnet-04bc3d5190e654987"         # Mention the created subnet else remove this field
  tags = {
    Name = var.EC2_name                                # Instance Name variable
  }
  key_name                    = var.key_pair           # .pem file variable
  associate_public_ip_address = var.assign_public_ip   # Auto assign public IP variable
}

