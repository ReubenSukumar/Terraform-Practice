provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "Terraform-Instance" {
  ami = "ami-0b6c6ebed2801a5cb"                     # Caution: Use 'free tier eligible'
  instance_type = "t3.micro"                        # Caution: Use 'free tier eligible'
  subnet_id = "subnet-04bc3d5190e963852"            # If Subnet is already created mention subnet else remove this field  
  security_groups = [ "sg-0e15788c553852741" ]      # If Security Group is already created mention else remove this field
  associate_public_ip_address = var.auto_ip         # Auto assign public IP variable
  key_name = var.pem                                # .pem file variable
  tags = {
    "Name" = var.EC2_name                           # Instance Name variable
  }
}