output "Instance_Public_IP" {
  value = module.Testing_Instance.Public_IP_Address          # Displays Public IP of Instance
}

output "Instance_Private_IP" {
  value = module.Testing_Instance.Private_IP_Address         # Displays Private IP of Instance
}

output "bucket_name" {
  value = module.terraform_bucket.S3_Bucket                   # Displays Bucket Name
}
