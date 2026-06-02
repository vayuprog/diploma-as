output "role_arn" {
  description = "IAM role ARN for GitHub Actions — set as DEPLOY_ROLE_ARN repo variable"
  value       = aws_iam_role.github_deploy.arn
}
