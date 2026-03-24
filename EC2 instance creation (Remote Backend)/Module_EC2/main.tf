resource "aws_instance" "Testing_Instance" {
  ami = "ami-0b6c6ebed2801a5cb"                           # Caution: Use 'free tier eligible'
  instance_type = "t3.micro"                              # Caution: Use 'free tier eligible'
  security_groups = [ "sg-0e15788c553987654" ]            # If Security Group is already created mention else remove this field 
  subnet_id = "subnet-04bc3d5190e456123"                  # Mention the created subnet else remove this field
  key_name = var.key_pair                                 # .pem file variable
  associate_public_ip_address = var.auto_public_ip        # Auto assign public IP variable
  tags = {
    Name = var.EC2_name                                   # Instance Name variable
  }
}
