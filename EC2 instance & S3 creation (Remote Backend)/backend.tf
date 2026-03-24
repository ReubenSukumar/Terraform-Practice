terraform {
  backend "s3" {  
    bucket = "terraform-fail-safe"                # Backend Bucket Name
    key    = "State Folder/terraform.tfstate"     # Path where statefile will be saved
    region = "ap-south-1"                         # Region where bucket exists
  }
}
