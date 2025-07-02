resource "aws_eip" "this" {

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}
