module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = var.domain_name
  subject_alternative_names = var.subject_alternative_names

  # DNS validation
  validate_certificate = true
  validation_method   = "DNS"

  # Wait for validation to complete
  wait_for_validation = true

  tags = var.tags
}
