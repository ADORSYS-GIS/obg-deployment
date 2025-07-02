output "id" {
  description = "ID of the Elastic IP"
  value       = aws_eip.this.id
}

output "public_ip" {
  description = "Public IP address"
  value       = aws_eip.this.public_ip
}
