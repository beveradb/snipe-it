resource "aws_acm_certificate" "bimtwin-acm-cert" {
  domain_name               = "bimtwin.ml"
  subject_alternative_names = ["*.bimtwin.ml"]
  validation_method         = "DNS"
  tags                      = local.tags
}

resource "aws_route53_record" "bimtwin-acm-route53-record" {
  for_each = {
    for dvo in aws_acm_certificate.bimtwin-acm-cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.bimtwin-route53-zone.zone_id
}

resource "aws_acm_certificate_validation" "bimtwin-acm-cert-validation" {
  certificate_arn         = aws_acm_certificate.bimtwin-acm-cert.arn
  validation_record_fqdns = [for record in aws_route53_record.bimtwin-acm-route53-record : record.fqdn]
}
