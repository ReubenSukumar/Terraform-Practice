provider "aws" {
  region = "us-east-1"                                  # Region where EC2 will be deployed
}

module "Trial_Instance" {                               # Module name used in EC2_Module/main.tf
  source           = "./EC2_Module"                     # Path of module
  key_pair         = "Treasure"                         # Key pair Name
  EC2_name         = "Terraform-Instance-Module-1"      # Instance Name
  assign_public_ip = true                               # Assign Public IP or not
}