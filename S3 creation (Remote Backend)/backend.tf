terraform {
  backend "s3" {
    bucket = "terraform-fail-safe"
    key    = "State Folder/terraform.tfstate"
    region = "ap-south-1"
    use_lockfile = true
  }
}
