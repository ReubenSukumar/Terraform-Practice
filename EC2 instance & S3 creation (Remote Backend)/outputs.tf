output "Instance_Public_IP" {
  value = module.Testing_Instance.Public_IP_Address
}

output "Instance_Private_IP" {
  value = module.Testing_Instance.Private_IP_Address
}

output "bucket_name" {
  value = module.terraform_bucket.S3_Bucket
}
