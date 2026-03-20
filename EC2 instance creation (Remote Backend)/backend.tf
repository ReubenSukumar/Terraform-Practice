terraform {
  backend "s3" {
    bucket = "terraform-fail-safe"                # Bucket Name where .tfstate file will be stored
    key    = "State Folder/terraform.tfstate"     # Path where .tfstate file will be stored
    region = "ap-south-1"                         # Region where bucket exists
  }
}
