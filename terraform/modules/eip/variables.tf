variable "name" {
  description = "Name tag for the EIP"
  type        = string
}

variable "environment" {
  description = "Environment (e.g. dev, prod)"
  type        = string
  default     = "dev"
}
