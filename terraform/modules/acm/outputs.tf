output "certificate_arn" {
  value = aws_acm_certificate.this.arn
}

# CNAME records to add in GoDaddy for DNS validation
output "validation_cnames" {
  description = "Add these CNAME records in GoDaddy DNS to validate the certificate"
  value = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      value = dvo.resource_record_value
      type  = dvo.resource_record_type
    }
  }
}

output "certificate_status" {
  value = aws_acm_certificate.this.status
}
