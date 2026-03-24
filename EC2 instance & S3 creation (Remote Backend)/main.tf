module "Testing_Instance" {               # Module name used in main.tf/Module_EC2
  source         = "./Module_EC2"         # Path of module
  key_pair       = "Treasure"             # .pem file name
  auto_public_ip = true                   # Assign Public IP
  EC2_name       = "Terra-Instance"       # Instance Name
}

module "terraform_bucket" {               # Module name used in main.tf/Module_S3
  source  = "./Module_S3"                 # Path of module
  s3_name = "reuben-terraform-testing"    # Bucket Name
}
