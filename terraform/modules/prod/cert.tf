provider "aws" {
  alias = "virginia"
  region = "us-east-1"
  profile = var.aws_profile
}

resource "aws_acm_certificate" "main" {
    domain_name = var.domain_name 
    subject_alternative_names = ["*.${var.domain_name}"]
    validation_method = "DNS"
    provider = aws.virginia
}

resource "aws_route53_record" "cert_validation" {
  allow_overwrite = true
  name =  tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_name
  records = [tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_value]
  type = tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_type
  zone_id = aws_route53_zone.main.zone_id
  ttl = 300
}

#resource "aws_acm_certificate_validation" "main" {
#    certificate_arn = aws_acm_certificate.main.arn
#    validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
#}