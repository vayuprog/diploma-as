output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "node_sg_id" {
  value = aws_security_group.node.id
}

output "falco_log_group_name" {
  value = aws_cloudwatch_log_group.falco.name
}

output "falco_log_group_arn" {
  value = aws_cloudwatch_log_group.falco.arn
}
