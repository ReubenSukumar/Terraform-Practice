provider "aws" {
  region = "us-east-1"
}

module "Terraform-Instance" {     # Module name used in main.tf/Module_EC2
  source   = "./Module_EC2"       # Path of module
  EC2_name = var.ecname           # Instance Name variable declared in root
  pem      = var.key-name         # Key pair variable declared in root
  auto_ip  = var.pub-ip           # Assign Public IP variable declared in root
}
