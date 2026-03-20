provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "Testing_Instance" {
  ami = "ami-0b6c6ebed2801a5cb"
  instance_type = "t3.micro"
  security_groups = [ "sg-0e15788c553321654" ]
  subnet_id = "subnet-04bc3d5190e987321"
  key_name = var.key_pair
  associate_public_ip_address = var.auto_public_ip
  tags = {
    Name = var.EC2_name
  }
}
