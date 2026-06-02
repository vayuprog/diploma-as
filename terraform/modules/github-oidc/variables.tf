variable "name" {
  description = "Project name prefix"
  type        = string
}

variable "github_repo" {
  description = "GitHub repo in owner/repo format (e.g. vayuprog/aws-security-lab)"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name the role will deploy to"
  type        = string
}
