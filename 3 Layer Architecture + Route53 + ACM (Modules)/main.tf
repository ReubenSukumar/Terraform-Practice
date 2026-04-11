module "vpc" {
  source                 = "./Module_VPC"
  CIDR                   = "20.0.0.0/16"
  Public_Subnet_1        = "20.0.1.0/24"  
  Public_Subnet_2        = "20.0.2.0/24"
  Private_Subnet_1       = "20.0.3.0/24"
  Private_Subnet_2       = "20.0.4.0/24"
  Private_DB_Subnet_1    = "20.0.5.0/24"
  Private_DB_Subnet_2    = "20.0.6.0/24"
  Public_Interface_id    = module.ec2.Public_Interface_ID
}

module "ec2" {
  source                 = "./Module_EC2"
  Pem_Name               = "Treasure"
  Public_Instance_1      = "Terraform-Public-Instance-1a"
  Public_Instance_2      = "Terraform-Public-Instance-1b"
  Private_Instance_1     = "Terraform-Private-Instance-1a"
  Private_Instance_2     = "Terraform-Private-Instance-1b"
  Private_DB_Instance_1  = "Terraform-DB-Master-Server-1a"
  Private_DB_Instance_2  = "Terraform-DB-Slave-Server-1b"
  Public_Instance_sg     = module.sg.Public_Instance_1_SG
  Private_Instance_sg    = module.sg.Private_Instance_1_SG
  Master_Instance_sg     = module.sg.Master_DB_SG
  Slave_Instance_sg      = module.sg.Slave_DB_SG
  Public_Subnet_1_id     = module.vpc.Public_Subnet_1_ID
  Public_Subnet_2_id     = module.vpc.Public_Subnet_2_ID
  Private_Subnet_1_id    = module.vpc.Private_Subnet_1_ID
  Private_Subnet_2_id    = module.vpc.Private_Subnet_2_ID
  DB_Subnet_1_id         = module.vpc.DB_Subnet_1_ID
  DB_Subnet_2_id         = module.vpc.DB_Subnet_2_ID
  private_alb_for_script = module.alb.private_alb_script
}

module "sg" {
  source                 = "./Module_Security_Group"
  vpc_id                 = module.vpc.id_vpc
}

module "alb" {
  source                 = "./Module_ALB_and_TG"
  Public_ALB_Name        = "Terraform-Public-ALB"
  Private_ALB_Name       = "Terraform-Private-ALB"  
  public_subnets         = module.vpc.public_subnet_ids
  private_subnets        = module.vpc.private_subnet_ids
  vpc_id                 = module.vpc.id_vpc
  public_1_instance_id   = module.ec2.Public_Instance_1_ID
  public_2_instance_id   = module.ec2.Public_Instance_2_ID
  private_1_instance_id  = module.ec2.Private_Instance_1_ID
  private_2_instance_id  = module.ec2.Private_Instance_1_ID
  public_alb_id          = module.sg.public_alb_security_group
  private_alb_id         = module.sg.private_alb_security_group
  acm_certify_validation = module.r53.acm_validation
}

module "r53" {
  source                 = "./Module_R53_ACM"
  Domain_Name            = "johnwick.lol"
  Certificate_Name       = "John Wick lol ACM" 
  public_alb_dns         = module.alb.public_alb_dns_r53
  public_alb_zone        = module.alb.public_alb_zone_r53
}