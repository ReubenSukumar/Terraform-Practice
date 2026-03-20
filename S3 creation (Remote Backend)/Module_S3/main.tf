provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "terraform_bucket" {
  bucket = var.s3_name                            # Bucket Name variable
}