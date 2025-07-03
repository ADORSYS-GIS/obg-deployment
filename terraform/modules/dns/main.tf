#data "aws_route53_zone" "main" {
#  name = var.domain_name
#}

# Wildcard DNS record pointing to the NAT Gateway's Elastic IP (EIP)
resource "aws_route53_record" "wildcard" {
  zone_id = var.zone_id
  name    = "*.${var.domain_name}"
  type    = "A"
  records = [var.target_domain_name]
  ttl     = 300
}

# Main domain record pointing to the NAT Gateway's Elastic IP (EIP)
resource "aws_route53_record" "main" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"
  records = [var.target_domain_name]
  ttl     = 300
}

# ACM certificate validation records
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in var.certificate_domain_validation_options : dvo.domain_name => {
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
  zone_id         = var.zone_id
}
