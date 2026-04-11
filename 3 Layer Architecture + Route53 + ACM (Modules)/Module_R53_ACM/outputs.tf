output "Domain_Name_" {
  description   = "Domain Name"
  value         = aws_route53_record.www.name
}

output "Certificate_Name_" {
  description   = "Certificate Name"
  value         = aws_acm_certificate.certify.tags["Name"]
}

output "acm_validation" {
  description   = "Certificate ARN"
  value         = aws_acm_certificate_validation.certificate_validation.certificate_arn
}