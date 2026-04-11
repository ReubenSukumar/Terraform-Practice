#####################################################                      EC2 Creation                     #######################################################



resource "aws_instance" "T_Public_Instance_1a" {
  ami                         = "ami-0b6c6ebed2801a5cb"                   # Caution: Use 'free tier eligible'
  instance_type               = "t3.micro"                                # Caution: Use 'free tier eligible'
  vpc_security_group_ids      = [var.Public_Instance_sg]                  # If Security Group is already created mention else remove this field 
  subnet_id                   = var.Public_Subnet_1_id                    # Mention the created subnet else remove this field
  source_dest_check           = false                                     # Required for NAT
  tags = {
    Name = var.Public_Instance_1                                          # Instance Name
  }
  key_name                    = var.Pem_Name                              # .pem file name
  associate_public_ip_address = true                                      # Auto assign public IP is enabled


  user_data                   = templatefile("${path.module}/../Scripts/nginx_and_nat.sh.tpl", {
    enable_nat       = true                                             
    install_nginx    = true                                               # ^-- Nginx and NAT Instance setup using nginx_and_nat.sh.tpl
    internal_alb_dns = var.private_alb_for_script
})
}

resource "aws_instance" "T_Public_Instance_1b" {
  ami                         = "ami-0b6c6ebed2801a5cb"                   # Caution: Use 'free tier eligible'
  instance_type               = "t3.micro"                                # Caution: Use 'free tier eligible'
  vpc_security_group_ids      = [var.Public_Instance_sg]                  # If Security Group is already created mention else remove this field 
  subnet_id                   = var.Public_Subnet_2_id                    # Mention the created subnet else remove this field
  tags = {
    Name = var.Public_Instance_2                                          # Instance Name
  }
  key_name                    = var.Pem_Name                              # .pem file name
  associate_public_ip_address = true                                      # Auto assign public IP is enabled


  user_data                   = templatefile("${path.module}/../Scripts/nginx_and_nat.sh.tpl", {
    enable_nat       = false
    install_nginx    = true                                               # ^-- Nginx setup using nginx_and_nat.sh.tpl
    internal_alb_dns = var.private_alb_for_script
})
}

resource "aws_instance" "T_Private_Instance_1a" {
  ami                         = "ami-0b6c6ebed2801a5cb"                   # Caution: Use 'free tier eligible'
  instance_type               = "t3.micro"                                # Caution: Use 'free tier eligible'
  vpc_security_group_ids      = [var.Private_Instance_sg]                 # If Security Group is already created mention else remove this field 
  subnet_id                   = var.Private_Subnet_1_id                   # Mention the created subnet else remove this field
  tags = {
    Name = var.Private_Instance_1                                         # Instance Name
  }
  key_name                    = var.Pem_Name                              # .pem file name
  associate_public_ip_address = false                                     # Auto assign public IP is disabled
}

resource "aws_instance" "T_Private_Instance_1b" {
  ami                         = "ami-0b6c6ebed2801a5cb"                   # Caution: Use 'free tier eligible'
  instance_type               = "t3.micro"                                # Caution: Use 'free tier eligible'
  vpc_security_group_ids      = [var.Private_Instance_sg]                 # If Security Group is already created mention else remove this field 
  subnet_id                   = var.Private_Subnet_2_id                   # Mention the created subnet else remove this field
  tags = {
    Name = var.Private_Instance_2                                         # Instance Name
  }
  key_name                    = var.Pem_Name                              # .pem file name
  associate_public_ip_address = false                                     # Auto assign public IP is disabled
}

resource "aws_instance" "T_DB_Private_Instance_1a" {
  ami                         = "ami-0b6c6ebed2801a5cb"                   # Caution: Use 'free tier eligible'
  instance_type               = "t3.micro"                                # Caution: Use 'free tier eligible'
  vpc_security_group_ids      = [var.Master_Instance_sg]                  # If Security Group is already created mention else remove this field 
  subnet_id                   = var.DB_Subnet_1_id                        # Mention the created subnet else remove this field
  tags = {
    Name = var.Private_DB_Instance_1                                      # Instance Name
  }
  key_name                    = var.Pem_Name                              # .pem file name
  associate_public_ip_address = false                                     # Auto assign public IP is disabled


  user_data                   = templatefile("${path.module}/../Scripts/mysql_master.sh.tpl", {})
}                                                                         # ^-- Master DB setup using mysql_master.sh.tpl

resource "aws_instance" "T_DB_Private_Instance_1b" {
  ami                         = "ami-0b6c6ebed2801a5cb"                   # Caution: Use 'free tier eligible'
  instance_type               = "t3.micro"                                # Caution: Use 'free tier eligible'
  vpc_security_group_ids      = [var.Slave_Instance_sg]                   # If Security Group is already created mention else remove this field 
  subnet_id                   = var.DB_Subnet_2_id                        # Mention the created subnet else remove this field
  tags = {
    Name = var.Private_DB_Instance_2                                      # Instance Name
  }
  key_name                    = var.Pem_Name                              # .pem file name
  associate_public_ip_address = false                                     # Auto assign public IP is disabled


  user_data                   = templatefile("${path.module}/../Scripts/mysql_slave.sh.tpl",

  {                                                                       # ^-- Slave DB setup using mysql_slave.sh.tpl

    master_ip = aws_instance.T_DB_Private_Instance_1a.private_ip          # master_ip variable used for mysql_slave.sh.tpl
    
  })
}