provider "aws" {
  region = "ap-south-1"             # Region where bucket should be created
}

module "terraform_bucket" {         # Module name used in Module_S3/main.tf
  source  = "./Module_S3"           # Path of module
  s3_name = "reuben-terra-testing"  # Bucket Name
}
