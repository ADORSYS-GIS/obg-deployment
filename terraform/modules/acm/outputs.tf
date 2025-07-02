output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = module.acm.acm_certificate_arn
}

output "certificate_domain_validation_options" {
  description = "Domain validation options for the certificate"
  value       = module.acm.acm_certificate_domain_validation_options
}
