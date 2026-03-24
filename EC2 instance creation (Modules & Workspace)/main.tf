module "apex_Instance" {            # Module name used in main.tf/EC2_Module
  source           = "./EC2_Module" # Path of module
  key_pair         = "Treasure"     # Key pair Name
  EC2_name         = var.ec2name    # Instance Name variable declared in root
  assign_public_ip = true           # Assign Public IP or not
}