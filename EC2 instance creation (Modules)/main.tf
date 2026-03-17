provider "aws" {
  region = "us-east-1"
}

module "Trial_Instance" {
  source           = "./EC2_Module"
  key_pair         = "Treasure"
  EC2_name         = "Terraform-Instance-Module-1"
  assign_public_ip = true
}