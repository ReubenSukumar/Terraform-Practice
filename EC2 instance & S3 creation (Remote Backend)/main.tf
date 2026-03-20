module "Testing_Instance" {
  source         = "./Module_EC2"
  key_pair       = "Treasure"
  auto_public_ip = true
  EC2_name       = "Terra-Instance"
}

module "terraform_bucket" {
  source  = "./Module_S3"
  s3_name = "reuben-terraform-testing"
}
