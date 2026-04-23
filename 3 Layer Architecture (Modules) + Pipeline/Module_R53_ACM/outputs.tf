output "Domain_Name_" {
  description   = "Domain Name"
  value         = aws_route53_record.www.name                                                   # Display Domain Name 
}

output "Certificate_Name_" {
  description   = "Certificate Name"
  value         = aws_acm_certificate.certify.tags["Name"]                                      # Display Certificate Name                         
}

output "acm_validation" {
  description   = "Certificate ARN"
  value         = aws_acm_certificate_validation.certificate_validation.certificate_arn         # Certificate ARN required for main.tf in Module_ALB_and_TG
}