###################################################                 VPC                 ################################################################


provider "aws" {
  region = "us-east-1"                                  # Region to be deployed
}

resource "aws_vpc" "vpc-T" {                            # Desired module name for VPC
  cidr_block       = "20.0.0.0/16"                      # CIDR Block
  instance_tenancy = "default"

  tags = {
    Name = "Terraform-VPC"                              # Desired name for VPC
  }
}

resource "aws_internet_gateway" "vpc-T-gw" {            
  vpc_id = aws_vpc.vpc-T.id

  tags = {
    Name = "Terraform-IG"                               # Desired name for Internet Gateway
  }
}

resource "aws_subnet" "vpc-sub-public-1" {              
  vpc_id                  = aws_vpc.vpc-T.id
  cidr_block              = "20.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"                # Define the AZ

  tags = {
    Name = "Terraform-Public-1a"                        # Desired name for subnet (Public Zone - 1)
  }
}

resource "aws_subnet" "vpc-sub-public-2" {              
  vpc_id                  = aws_vpc.vpc-T.id
  cidr_block              = "20.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"                # Define the AZ

  tags = {
    Name = "Terraform-Public-1b"                        # Desired name for subnet (Public Zone - 2)
  }
}


resource "aws_route_table" "vpc-public-rt" {            
  vpc_id    = aws_vpc.vpc-T.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-T-gw.id 
  }

  tags = {
    Name = "Terraform-Public-RT"                         # Desired name for Route Table (Public)
  }
}

resource "aws_route_table_association" "vpc-public-1-rt" {              # Associate the Public Subnet 1a to Public Route Table
  subnet_id      = aws_subnet.vpc-sub-public-1.id
  route_table_id = aws_route_table.vpc-public-rt.id
}

resource "aws_route_table_association" "vpc-public-2-rt" {              # Associate the Public Subnet 1b to Public Route Table
  subnet_id      = aws_subnet.vpc-sub-public-2.id
  route_table_id = aws_route_table.vpc-public-rt.id
}

resource "aws_subnet" "vpc-sub-private-1" {                             
  vpc_id                  = aws_vpc.vpc-T.id
  cidr_block              = "20.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"                                

  tags = {
    Name = "Terraform-Private-1a"                                       # Desired name for subnet (Private Zone - 1) 
  }
}

resource "aws_subnet" "vpc-sub-private-2" {                             
  vpc_id                  = aws_vpc.vpc-T.id
  cidr_block              = "20.0.4.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"                          

  tags = {
    Name = "Terraform-Private-1b"                                       # Desired name for subnet (Private Zone - 2)
  }
}

resource "aws_route_table" "vpc-private-rt" {
  vpc_id = aws_vpc.vpc-T.id

  tags = {
    Name = "Terraform-Private-RT"                                       # Desired name for Route Table (Private)                    
  }
}

resource "aws_route" "pri_NAT_instance" {
  route_table_id          = aws_route_table.vpc-private-rt.id                      # Configure NAT instance for Private Route Table
  destination_cidr_block  = "0.0.0.0/0"
  network_interface_id    = aws_instance.Terraform-Pub-Instance-1a.primary_network_interface_id
}

resource "aws_route_table_association" "vpc-sub-private-1-rt" {                    # Associate the Private Subnet 1a to Private Route Table
  subnet_id      = aws_subnet.vpc-sub-private-1.id
  route_table_id = aws_route_table.vpc-private-rt.id
}

resource "aws_route_table_association" "vpc-sub-private-2-rt" {                    # Associate the Private Subnet 1b to Private Route Table
  subnet_id      = aws_subnet.vpc-sub-private-2.id
  route_table_id = aws_route_table.vpc-private-rt.id
}




resource "aws_subnet" "vpc_sub_DB_private_1" {                             
  vpc_id                  = aws_vpc.vpc-T.id
  cidr_block              = "20.0.5.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"                                

  tags = {
    Name = "Terraform-DB-Private-1a"                                       # Desired name for subnet (DB Private Zone - 1) 
  }
}

resource "aws_subnet" "vpc_sub_DB_private_2" {                             
  vpc_id                  = aws_vpc.vpc-T.id
  cidr_block              = "20.0.6.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"                          

  tags = {
    Name = "Terraform-DB-Private-1b"                                       # Desired name for subnet (DB Private Zone - 2)
  }
}

resource "aws_route_table" "vpc_DB_private_rt" {
  vpc_id = aws_vpc.vpc-T.id

  tags = {
    Name = "Terraform-DB-Private-RT"                                       # Desired name for Route Table (Private)                    
  }
}

resource "aws_route" "pri_NAT_instance_to_DB" {
  route_table_id          = aws_route_table.vpc_DB_private_rt.id                      # Configure NAT instance for Private Route Table
  destination_cidr_block  = "0.0.0.0/0"
  network_interface_id    = aws_instance.Terraform-Pub-Instance-1a.primary_network_interface_id
}

resource "aws_route_table_association" "vpc_DB_sub_private_1_rt" {                    # Associate the Private Subnet 1a to Private Route Table
  subnet_id      = aws_subnet.vpc_sub_DB_private_1.id
  route_table_id = aws_route_table.vpc_DB_private_rt.id
}

resource "aws_route_table_association" "vpc_DB_sub_private_2_rt" {                    # Associate the Private Subnet 1b to Private Route Table
  subnet_id      = aws_subnet.vpc_sub_DB_private_2.id
  route_table_id = aws_route_table.vpc_DB_private_rt.id
}




#################################################                       Security Groups                     #########################################################




resource "aws_security_group" "T_Pub_SG" {                                               # Public Instance Security Group
  name       	= "Terraform-Public-SG"
  description	= "Allow SSH from my IP, HTTP/HTTPS from Public ALB inbound traffic and all outbound traffic"
  vpc_id     	= aws_vpc.vpc-T.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_pub" {
  security_group_id	= aws_security_group.T_Pub_SG.id
  cidr_ipv4         	= "<MY-IP>"                                                        # Allow SSH from My IP 
  from_port         	= 22
  ip_protocol       	= "tcp"
  to_port           	= 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_pub" {
  security_group_id 		        = aws_security_group.T_Pub_SG.id                         # Allow HTTPS from Public ALB (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_ALB_pub_SG.id
  from_port         		        = 443
  ip_protocol       		        = "tcp"
  to_port           		        = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_pub" {
  security_group_id           	= aws_security_group.T_Pub_SG.id
  referenced_security_group_id	= aws_security_group.T_ALB_pub_SG.id                     # Allow HTTP from Public ALB (Inbound Traffic)
  from_port         	      	  = 80
  ip_protocol       		        = "tcp"
  to_port           		        = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_from_pub_pri" {
  security_group_id           	= aws_security_group.T_Pub_SG.id                         # Allow HTTPS from Public Instance to Private Instance (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_Pri_SG.id
  ip_protocol                   = "-1"       # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_pub" {
  security_group_id	= aws_security_group.T_Pub_SG.id
  cidr_ipv4        	= "0.0.0.0/0"                                                        # Allow all Outbound Traffic
  ip_protocol      	= "-1"         # semantically equivalent to all ports
}

resource "aws_security_group" "T_Pri_SG" {                                               # Private Instance Security Group
  name       	= "Terraform-Private-SG"
  description	= "Allow SSH inbound traffic from Public Instance, allow TCP 3000 from Private ALB and all outbound traffic"
  vpc_id     	= aws_vpc.vpc-T.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_pri" {
  security_group_id		          = aws_security_group.T_Pri_SG.id                         # Allow SSH from Public Instance (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_Pub_SG.id
  from_port         		        = 22
  ip_protocol       		        = "tcp"
  to_port           		        = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_pub_instance_to_pri_JAR" {
  security_group_id		          = aws_security_group.T_Pri_SG.id                         # Allow Port 3000 from Public Instance to Private Instance (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_ALB_pri_SG.id
  from_port         		        = 3000
  ip_protocol       		        = "tcp"
  to_port           		        = 3000
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_pri" {
  security_group_id	  = aws_security_group.T_Pri_SG.id
  cidr_ipv4         	= "0.0.0.0/0"                                                      # Allow All Outbound Traffic
  ip_protocol       	= "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "T_ALB_pub_SG" {                                           # Public ALB Security Group           
  name        = "Terraform-Public-ALB-SG"
  description = "Allow HTTP/HTTPS inbound traffic from Public Instance and all outbound traffic"
  vpc_id      = aws_vpc.vpc-T.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_to_pub_alb" {
  security_group_id = aws_security_group.T_ALB_pub_SG.id                                 # Allow HTTPS to Public ALB (Inbound Traffic)
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_to_pub_alb" {
  security_group_id = aws_security_group.T_ALB_pub_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80                                                                 # Allow HTTP to Public ALB (Inbound Traffic)
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_traffic_to_pub" {
  security_group_id = aws_security_group.T_ALB_pub_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "T_ALB_pri_SG" {                                           # Private ALB Security Group
  name        = "Terraform-Private-ALB-SG"
  description = "Allow JAR port/HTTP inbound traffic from Public Instance and all outbound traffic"
  vpc_id      = aws_vpc.vpc-T.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_pub_instance_to_pri_alb_JAR" {
  security_group_id 	         = aws_security_group.T_ALB_pri_SG.id
  referenced_security_group_id = aws_security_group.T_Pub_SG.id                          # Allow Port 3000 from Public Instance to Private ALB
  from_port         	         = 3000
  ip_protocol                  = "tcp"
  to_port                      = 3000
}

resource "aws_vpc_security_group_ingress_rule" "allow_pub_instance_to_pri_alb_http" {    # Allow HTTP from Public Instance to Private ALB
  security_group_id	           = aws_security_group.T_ALB_pri_SG.id
  referenced_security_group_id = aws_security_group.T_Pub_SG.id
  from_port                    = 80
  ip_protocol       	         = "tcp"
  to_port           	         = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_traffic_to_pri" {      # Allow All Outbound Traffic 
  security_group_id = aws_security_group.T_ALB_pri_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_security_group" "T_Master_DB_SG" {                                         # Master DB Security Group
  name       	= "Terraform-Master-DB-SG"
  description	= "Allow SSH inbound traffic from Public Instance, allow TCP 3306 from Private Instance & all outbound traffic"
  vpc_id     	= aws_vpc.vpc-T.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_to_master_db_from_pub" {
  security_group_id		          = aws_security_group.T_Master_DB_SG.id                   # Allow SSH from Public Instance (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_Pub_SG.id
  from_port         		        = 22
  ip_protocol       		        = "tcp"
  to_port           		        = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_pri_instance_to_master_db" {
  security_group_id		          = aws_security_group.T_Master_DB_SG.id                   # Allow Port 3306 from Private Instance to Master DB (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_Pri_SG.id
  from_port         		        = 3306
  ip_protocol       		        = "tcp"
  to_port           		        = 3306
}


resource "aws_vpc_security_group_ingress_rule" "allow_slave_db_to_master_db" {
  security_group_id		          = aws_security_group.T_Master_DB_SG.id                   # Allow Port 3306 from Slave DB to Master DB (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_Slave_DB_SG.id
  from_port         		        = 3306
  ip_protocol       		        = "tcp"
  to_port           		        = 3306
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_master_db" {
  security_group_id	  = aws_security_group.T_Master_DB_SG.id
  cidr_ipv4         	= "0.0.0.0/0"                                                      # Allow All Outbound Traffic
  ip_protocol       	= "-1" # semantically equivalent to all ports
}



resource "aws_security_group" "T_Slave_DB_SG" {                                          # Slave DB Security Group
  name       	= "Terraform-Slave-DB-SG"
  description	= "Allow SSH inbound traffic from Public Instance, allow TCP 3306 from Private Instance & all outbound traffic"
  vpc_id     	= aws_vpc.vpc-T.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_to_slave_db_from_pub" {
  security_group_id		          = aws_security_group.T_Slave_DB_SG.id                    # Allow SSH from Public Instance (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_Pub_SG.id
  from_port         		        = 22
  ip_protocol       		        = "tcp"
  to_port           		        = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_pri_instance_to_slave_db" {
  security_group_id		          = aws_security_group.T_Slave_DB_SG.id                    # Allow Port 3306 from Private Instance to Slave DB (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_Pri_SG.id
  from_port         		        = 3306
  ip_protocol       		        = "tcp"
  to_port           		        = 3306
}

resource "aws_vpc_security_group_ingress_rule" "allow_master_db_to_slave_db" {
  security_group_id		          = aws_security_group.T_Slave_DB_SG.id                    # Allow Port 3306 from Master DB to Slave DB (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_Master_DB_SG.id
  from_port         		        = 3306
  ip_protocol       		        = "tcp"
  to_port           		        = 3306
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_slave_db" {
  security_group_id	  = aws_security_group.T_Slave_DB_SG.id
  cidr_ipv4         	= "0.0.0.0/0"                                                      # Allow All Outbound Traffic
  ip_protocol       	= "-1" # semantically equivalent to all ports
}




#####################################################                      EC2 Creation                     #######################################################




resource "aws_instance" "Terraform-Pub-Instance-1a" {
  ami                         = "ami-0b6c6ebed2801a5cb"                   # Caution: Use 'free tier eligible'
  instance_type               = "t3.micro"                                # Caution: Use 'free tier eligible'
  vpc_security_group_ids      = [aws_security_group.T_Pub_SG.id]          # If Security Group is already created mention else remove this field 
  subnet_id                   = aws_subnet.vpc-sub-public-1.id            # Mention the created subnet else remove this field
  source_dest_check           = false                                     # Required for NAT
  tags = {
    Name = "Terraform-Public-Instance-1a"                                 # Instance Name
  }
  key_name                    = "Test"                                    # .pem file name
  associate_public_ip_address = true                                      # Auto assign public IP is enabled
}

resource "aws_instance" "Terraform-Pub-Instance-1b" {
  ami                         = "ami-0b6c6ebed2801a5cb"                   # Caution: Use 'free tier eligible'
  instance_type               = "t3.micro"                                # Caution: Use 'free tier eligible'
  vpc_security_group_ids      = [aws_security_group.T_Pub_SG.id]          # If Security Group is already created mention else remove this field 
  subnet_id                   = aws_subnet.vpc-sub-public-2.id            # Mention the created subnet else remove this field
  tags = {
    Name = "Terraform-Public-Instance-1b"                                 # Instance Name
  }
  key_name                    = "Test"                                    # .pem file name
  associate_public_ip_address = true                                      # Auto assign public IP is enabled
}

resource "aws_instance" "Terraform-Priv-Instance-1a" {
  ami                         = "ami-0b6c6ebed2801a5cb"                   # Caution: Use 'free tier eligible'
  instance_type               = "t3.micro"                                # Caution: Use 'free tier eligible'
  vpc_security_group_ids      = [aws_security_group.T_Pri_SG.id]          # If Security Group is already created mention else remove this field 
  subnet_id                   = aws_subnet.vpc-sub-private-1.id           # Mention the created subnet else remove this field
  tags = {
    Name = "Terraform-Private-Instance-1a"                                # Instance Name
  }
  key_name                    = "Test"                                    # .pem file name
  associate_public_ip_address = false                                     # Auto assign public IP is disabled
}

resource "aws_instance" "Terraform-Priv-Instance-1b" {
  ami                         = "ami-0b6c6ebed2801a5cb"                   # Caution: Use 'free tier eligible'
  instance_type               = "t3.micro"                                # Caution: Use 'free tier eligible'
  vpc_security_group_ids      = [aws_security_group.T_Pri_SG.id]          # If Security Group is already created mention else remove this field 
  subnet_id                   = aws_subnet.vpc-sub-private-2.id           # Mention the created subnet else remove this field
  tags = {
    Name = "Terraform-Private-Instance-1b"                                # Instance Name
  }
  key_name                    = "Test"                                    # .pem file name
  associate_public_ip_address = false                                     # Auto assign public IP is disabled
}

resource "aws_instance" "Terraform_DB_Pri_Instance_1a" {
  ami                         = "ami-0b6c6ebed2801a5cb"                   # Caution: Use 'free tier eligible'
  instance_type               = "t3.micro"                                # Caution: Use 'free tier eligible'
  vpc_security_group_ids      = [aws_security_group.T_Master_DB_SG.id]    # If Security Group is already created mention else remove this field 
  subnet_id                   = aws_subnet.vpc_sub_DB_private_1.id        # Mention the created subnet else remove this field
  tags = {
    Name = "Terraform-DB-Master-Server-1a"                                # Instance Name
  }
  key_name                    = "Test"                                    # .pem file name
  associate_public_ip_address = false                                     # Auto assign public IP is disabled
}

resource "aws_instance" "Terraform_DB_Pri_Instance_1b" {
  ami                         = "ami-0b6c6ebed2801a5cb"                   # Caution: Use 'free tier eligible'
  instance_type               = "t3.micro"                                # Caution: Use 'free tier eligible'
  vpc_security_group_ids      = [aws_security_group.T_Slave_DB_SG.id]     # If Security Group is already created mention else remove this field 
  subnet_id                   = aws_subnet.vpc_sub_DB_private_2.id        # Mention the created subnet else remove this field
  tags = {
    Name = "Terraform-DB-Slave-Server-1b"                                 # Instance Name
  }
  key_name                    = "Test"                                    # .pem file name
  associate_public_ip_address = false                                     # Auto assign public IP is disabled
}





####################################################             Application Load  Balancer              #####################################################################





resource "aws_lb" "pub_alb_t" {
  name               = "Terraform-Public-ALB"                             # Desired name for Public ALB
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.T_ALB_pub_SG.id]
  subnets            = [aws_subnet.vpc-sub-public-1.id,                   # Subnets to be included for Public ALB
                        aws_subnet.vpc-sub-public-2.id]

  enable_deletion_protection = false                                      # *NOTE*: Setting this to `true` will prevent Terraform from destroying the resource
}


resource "aws_lb" "pri_alb_t" {
  name               = "Terraform-Private-ALB"                            # Desired name for Private ALB
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.T_ALB_pri_SG.id]
  subnets            = [aws_subnet.vpc-sub-private-1.id,                  # Subnets to be included for Private ALB
                        aws_subnet.vpc-sub-private-2.id]                

  enable_deletion_protection = false                                      # *NOTE*: Setting this to `true` will prevent Terraform from destroying the resource
}




####################################################               Target Group                 ###########################################################################




resource "aws_lb_target_group" "pub_alb_tg" {                                    # Public ALB TG
  name      = "Terraform-Public-ALB"
  port      = 80
  protocol  = "HTTP"
  vpc_id    = aws_vpc.vpc-T.id
  health_check {
    enabled             = true
    path                = "/health"
    port                = "traffic-port"  # Use the same port as the target
    protocol            = "HTTP"
    healthy_threshold   = 5               # Consecutive successes to mark healthy
    unhealthy_threshold = 2               # Consecutive failures to mark unhealthy
    timeout             = 5               # Seconds to wait for a response
    interval            = 30              # Seconds between checks
    matcher             = "200"           # Expected HTTP status code
  }
}

resource "aws_lb_listener" "pub_alb_listener" {
  load_balancer_arn = aws_lb.pub_alb_t.arn                                       # Define Listener Rule for Public ALB
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pub_alb_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "pub_alb_tg_EC2_sub1_attachment" {     # Attach the Instance to Target Group (Public ALB)
  target_group_arn = aws_lb_target_group.pub_alb_tg.arn
  target_id        = aws_instance.Terraform-Pub-Instance-1a.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "pub_alb_tg_EC2_sub2_attachment" {     # Attach the Instance to Target Group (Public ALB)
  target_group_arn = aws_lb_target_group.pub_alb_tg.arn
  target_id        = aws_instance.Terraform-Pub-Instance-1b.id
  port             = 80
}



resource "aws_lb_target_group" "pri_alb_tg" {                                    # Private ALB TG
  name      = "Terraform-Private-ALB"
  port      = 3000
  protocol  = "HTTP"
  vpc_id    = aws_vpc.vpc-T.id
  health_check {
    enabled             = true
    path                = "/health"
    port                = "traffic-port"  # Use the same port as the target
    protocol            = "HTTP"
    healthy_threshold   = 5               # Consecutive successes to mark healthy
    unhealthy_threshold = 2               # Consecutive failures to mark unhealthy
    timeout             = 5               # Seconds to wait for a response
    interval            = 30              # Seconds between checks
    matcher             = "200"           # Expected HTTP status code
  }
}

resource "aws_lb_listener" "pri_alb_listener" {                                  # Define Listener Rule for Private ALB
  load_balancer_arn = aws_lb.pri_alb_t.arn
  port              = "3000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pri_alb_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "pri_alb_tg_EC2_sub1_attachment" {
  target_group_arn = aws_lb_target_group.pri_alb_tg.arn                          # Attach the Instance to Target Group (Private ALB)
  target_id        = aws_instance.Terraform-Priv-Instance-1a.id
  port             = 3000
}

resource "aws_lb_target_group_attachment" "pri_alb_tg_EC2_sub2_attachment" {
  target_group_arn = aws_lb_target_group.pri_alb_tg.arn
  target_id        = aws_instance.Terraform-Priv-Instance-1b.id                  # Attach the Instance to Target Group (Private ALB)
  port             = 3000
}



#############################################################                  EOF                      ###############################################################