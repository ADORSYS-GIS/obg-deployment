output "hosted_zone_id" {
  description = "ID of the Route53 hosted zone"
  value       = data.aws_route53_zone.main.zone_id
}

output "hosted_zone_name_servers" {
  description = "Name servers of the Route53 hosted zone"
  value       = data.aws_route53_zone.main.name_servers
}

output "wildcard_record_name" {
  description = "Name of the wildcard DNS record"
  value       = aws_route53_record.wildcard.name
}

output "main_record_name" {
  description = "Name of the main domain DNS record"
  value       = aws_route53_record.main.name
}
