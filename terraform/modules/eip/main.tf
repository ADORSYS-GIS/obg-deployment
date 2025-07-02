resource "aws_eip" "this" {
  domain = "vpc"

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}
