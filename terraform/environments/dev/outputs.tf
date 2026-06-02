output "vpc_id" {
  value = module.vpc.vpc_id
}

output "region" {
  value = var.region
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "lb_controller_role_arn" {
  description = "Pass this to helm install aws-load-balancer-controller"
  value       = module.eks.lb_controller_role_arn
}

output "alb_sg_id" {
  description = "Put this value in k8s/ingress.yaml annotation alb.ingress.kubernetes.io/security-groups"
  value       = module.security.alb_sg_id
}

output "waf_acl_arn" {
  description = "Put this value in k8s/ingress.yaml annotation alb.ingress.kubernetes.io/wafv2-acl-arn"
  value       = module.waf.web_acl_arn
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "falco_log_group" {
  value = module.security.falco_log_group_name
}

output "kubeconfig_command" {
  description = "Run this to configure kubectl after apply"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.region}"
}

output "acm_certificate_arn" {
  description = "Paste this into k8s/ingress.yaml certificate-arn annotation"
  value       = module.acm.certificate_arn
}

output "acm_validation_cnames" {
  description = "Add these CNAME records in GoDaddy to validate the certificate"
  value       = module.acm.validation_cnames
}

output "acm_status" {
  value = module.acm.certificate_status
}
