resource "aws_route53_zone" "example" {
  name                      = var.Domain_Name
}

resource "aws_route53_record" "www" {                                               # Main DNS Record (ALB → Domain Mapping)
  zone_id                   = aws_route53_zone.example.zone_id
  name                      = var.Domain_Name
  type                      = "A"
  alias {
    name                    = var.public_alb_dns
    zone_id                 = var.public_alb_zone
    evaluate_target_health  = true
  }
}

resource "aws_acm_certificate" "certify" {
  domain_name               = var.Domain_Name
  validation_method         = "DNS"

  tags = {
    Name = var.Certificate_Name
  }

  lifecycle {
    create_before_destroy   = true
  }
}

resource "aws_route53_record" "domain_record" {
  for_each = {
    for dvo in aws_acm_certificate.certify.domain_validation_options : dvo.domain_name => {
      name                  = dvo.resource_record_name
      record                = dvo.resource_record_value                             # ACM DNS Validation Records
      type                  = dvo.resource_record_type
    }
  }

  allow_overwrite           = true
  name                      = each.value.name
  records                   = [each.value.record]
  ttl                       = 60
  type                      = each.value.type
  zone_id                   = aws_route53_zone.example.zone_id
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn           = aws_acm_certificate.certify.arn
  validation_record_fqdns   = [for record in aws_route53_record.domain_record : record.fqdn]
}