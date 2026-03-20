provider "aws" {
  region = "us-east-1"
}

module "Testing_Instance" {                 # Module name used in Module_EC2/main.tf
  source         = "./Module_EC2"           # Path of module
  key_pair       = "Treasure"               # Key pair Name
  auto_public_ip = true                     # Assign Public IP or not
  EC2_name       = "Terra-Instance"         # Instance Name
}
