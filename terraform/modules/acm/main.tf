variable "domain_name" {
  description = "Primary domain (e.g. vayuprogdimloma.biz)"
  type        = string
}

# ACM certificate covering both root and www
resource "aws_acm_certificate" "this" {
  domain_name               = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = var.domain_name
  }
}
