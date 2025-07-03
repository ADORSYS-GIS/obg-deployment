output "hosted_zone_id" {
  description = "The ID of the Route53 hosted zone"
  value       = var.zone_id
}

output "wildcard_record_name" {
  description = "Name of the wildcard DNS record"
  value       = aws_route53_record.wildcard.name
}

output "main_record_name" {
  description = "Name of the main domain DNS record"
  value       = aws_route53_record.main.name
}
