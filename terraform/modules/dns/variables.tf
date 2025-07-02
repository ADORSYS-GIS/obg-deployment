variable "domain_name" {
  description = "Domain name for the hosted zone"
  type        = string
}

variable "target_domain_name" {
  description = "Target domain name for the A record alias"
  type        = string
}

variable "certificate_domain_validation_options" {
  description = "Domain validation options from ACM certificate"
  type = list(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
  default = []
}
