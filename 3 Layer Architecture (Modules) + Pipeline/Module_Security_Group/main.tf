#################################################                       Security Groups                     #########################################################



resource "aws_security_group" "T_Public_SG" {                                               # Public Instance Security Group
  name       	                  = "Terraform-Public-SG"
  description	                  = "Allow SSH from my IP, HTTP/HTTPS from Public ALB inbound traffic & all outbound traffic"
  vpc_id     	                  = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_public" {
  security_group_id	            = aws_security_group.T_Public_SG.id
  cidr_ipv4         	          = "0.0.0.0/0"                                        #"122.171.19.228/32"               # Allow SSH from My IP 
  from_port         	          = 22
  ip_protocol       	          = "tcp"
  to_port           	          = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_public" {
  security_group_id 		        = aws_security_group.T_Public_SG.id                         # Allow HTTPS from Public ALB (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_ALB_public_SG.id
  from_port         		        = 443
  ip_protocol       		        = "tcp"
  to_port           		        = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_public" {
  security_group_id           	= aws_security_group.T_Public_SG.id
  referenced_security_group_id	= aws_security_group.T_ALB_public_SG.id                     # Allow HTTP from Public ALB (Inbound Traffic)
  from_port         	      	  = 80
  ip_protocol       		        = "tcp"
  to_port           		        = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_from_public_to_private" {
  security_group_id           	= aws_security_group.T_Public_SG.id                         # Allow HTTP from Public Instance to Private Instance (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_Private_SG.id
  ip_protocol      	            = "-1"         # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_public" {
  security_group_id	            = aws_security_group.T_Public_SG.id
  cidr_ipv4        	            = "0.0.0.0/0"                                               # Allow all Outbound Traffic
  ip_protocol      	            = "-1"         # semantically equivalent to all ports
}








resource "aws_security_group" "T_Private_SG" {                                              # Private Instance Security Group
  name       	                  = "Terraform-Private-SG"
  description	                  = "Allow SSH inbound traffic from Public Instance, allow TCP 3000 from Private ALB & all outbound traffic"
  vpc_id     	                  = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_private" {
  security_group_id		          = aws_security_group.T_Private_SG.id                        # Allow SSH from Public Instance (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_Public_SG.id
  from_port         		        = 22
  ip_protocol       		        = "tcp"
  to_port           		        = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_private_ALB_to_private_JAR" {
  security_group_id		          = aws_security_group.T_Private_SG.id                        # Allow Port 8080 from Private ALB to Private Instance (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_ALB_private_SG.id
  from_port         		        = 8080
  ip_protocol       		        = "tcp"
  to_port           		        = 8080
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_private" {
  security_group_id	            = aws_security_group.T_Private_SG.id
  cidr_ipv4         	          = "0.0.0.0/0"                                               # Allow All Outbound Traffic
  ip_protocol       	          = "-1" # semantically equivalent to all ports
}








resource "aws_security_group" "T_ALB_public_SG" {                                           # Public ALB Security Group           
  name                          = "Terraform-Public-ALB-SG"
  description                   = "Allow HTTP/HTTPS inbound traffic from Public Instance & all outbound traffic"
  vpc_id                        = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_to_public_alb" {
  security_group_id             = aws_security_group.T_ALB_public_SG.id                     # Allow HTTPS to Public ALB (Inbound Traffic)
  cidr_ipv4                     = "0.0.0.0/0"
  from_port                     = 443
  ip_protocol                   = "tcp"
  to_port                       = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_to_public_alb" {
  security_group_id             = aws_security_group.T_ALB_public_SG.id
  cidr_ipv4                     = "0.0.0.0/0"
  from_port                     = 80                                                        # Allow HTTP to Public ALB (Inbound Traffic)
  ip_protocol                   = "tcp"
  to_port                       = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_traffic_to_public" {
  security_group_id             = aws_security_group.T_ALB_public_SG.id
  cidr_ipv4                     = "0.0.0.0/0"
  ip_protocol                   = "-1" # semantically equivalent to all ports
}








resource "aws_security_group" "T_ALB_private_SG" {                                          # Private ALB Security Group
  name                          = "Terraform-Private-ALB-SG"
  description                   = "Allow JAR port/HTTP inbound traffic from Public Instance & all outbound traffic"
  vpc_id                        = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_public_instance_to_private_alb_JAR" {
  security_group_id 	          = aws_security_group.T_ALB_private_SG.id
  referenced_security_group_id  = aws_security_group.T_Public_SG.id                         # Allow Port 3000 from Public Instance to Private ALB
  from_port         	          = 8080
  ip_protocol                   = "tcp"
  to_port                       = 8080
}

resource "aws_vpc_security_group_ingress_rule" "allow_public_instance_to_private_alb_http" {    
  security_group_id	            = aws_security_group.T_ALB_private_SG.id
  referenced_security_group_id  = aws_security_group.T_Public_SG.id                         # Allow HTTP from Public Instance to Private ALB
  from_port                     = 80
  ip_protocol       	          = "tcp"
  to_port           	          = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_traffic_to_private" {     # Allow All Outbound Traffic 
  security_group_id             = aws_security_group.T_ALB_private_SG.id
  cidr_ipv4                     = "0.0.0.0/0"
  ip_protocol                   = "-1" # semantically equivalent to all ports
}








resource "aws_security_group" "T_Master_DB_SG" {                                            # Master DB Security Group
  name       	                  = "Terraform-Master-DB-SG"
  description	                  = "Allow SSH inbound traffic from Public Instance, allow TCP 3306 from Private Instance & all outbound traffic"
  vpc_id     	                  = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_to_master_db_from_public" {
  security_group_id		          = aws_security_group.T_Master_DB_SG.id                      # Allow SSH from Public Instance (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_Public_SG.id
  from_port         		        = 22
  ip_protocol       		        = "tcp"
  to_port           		        = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_private_instance_to_master_db" {
  security_group_id		          = aws_security_group.T_Master_DB_SG.id                      # Allow Port 3306 from Private Instance to Master DB (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_Private_SG.id
  from_port         		        = 3306
  ip_protocol       		        = "tcp"
  to_port           		        = 3306
}


resource "aws_vpc_security_group_ingress_rule" "allow_slave_db_to_master_db" {
  security_group_id		          = aws_security_group.T_Master_DB_SG.id                      # Allow Port 3306 from Slave DB to Master DB (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_Slave_DB_SG.id
  from_port         		        = 3306
  ip_protocol       		        = "tcp"
  to_port           		        = 3306
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_from_public_to_master" {
  security_group_id           	= aws_security_group.T_Public_SG.id                         # Allow HTTP from Public Instance to Master Instance (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_Master_DB_SG.id
  ip_protocol      	            = "-1"         # semantically equivalent to all ports
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_master_db" {
  security_group_id	            = aws_security_group.T_Master_DB_SG.id
  cidr_ipv4         	          = "0.0.0.0/0"                                               # Allow All Outbound Traffic
  ip_protocol       	          = "-1" # semantically equivalent to all ports
}








resource "aws_security_group" "T_Slave_DB_SG" {                                             # Slave DB Security Group
  name       	                  = "Terraform-Slave-DB-SG"
  description	                  = "Allow SSH inbound traffic from Public Instance, allow TCP 3306 from Private Instance & all outbound traffic"
  vpc_id     	                  = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_to_slave_db_from_pub" {
  security_group_id		          = aws_security_group.T_Slave_DB_SG.id                       # Allow SSH from Public Instance (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_Public_SG.id
  from_port         		        = 22
  ip_protocol       		        = "tcp"
  to_port           		        = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_to_slave_db_from_master" {
  security_group_id		          = aws_security_group.T_Slave_DB_SG.id                       # Allow SSH from Master Instance (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_Master_DB_SG.id
  from_port         		        = 22
  ip_protocol       		        = "tcp"
  to_port           		        = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_pri_instance_to_slave_db" {
  security_group_id		          = aws_security_group.T_Slave_DB_SG.id                       # Allow Port 3306 from Private Instance to Slave DB (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_Private_SG.id
  from_port         		        = 3306
  ip_protocol       		        = "tcp"
  to_port           		        = 3306
}

resource "aws_vpc_security_group_ingress_rule" "allow_master_db_to_slave_db" {
  security_group_id		          = aws_security_group.T_Slave_DB_SG.id                       # Allow Port 3306 from Master DB to Slave DB (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_Master_DB_SG.id
  from_port         		        = 3306
  ip_protocol       		        = "tcp"
  to_port           		        = 3306
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_from_public_to_slave" {
  security_group_id           	= aws_security_group.T_Public_SG.id                         # Allow HTTP from Public Instance to Slave Instance (Inbound Traffic)
  referenced_security_group_id	= aws_security_group.T_Slave_DB_SG.id
  ip_protocol      	            = "-1"         # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_slave_db" {
  security_group_id	            = aws_security_group.T_Slave_DB_SG.id
  cidr_ipv4         	          = "0.0.0.0/0"                                               # Allow All Outbound Traffic
  ip_protocol       	          = "-1" # semantically equivalent to all ports
}