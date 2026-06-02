variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "eu-central-1"
}

variable "name" {
  description = "Project name prefix used for all resource names"
  type        = string
  default     = "juice-lab"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "juice-shop-dev"
}

variable "allowed_cidr" {
  description = "Your public IP CIDR for kubectl access (e.g. 1.2.3.4/32)"
  type        = string
}

variable "azs" {
  description = "Availability zones to use (must be at least 2)"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "t3.small"
}

variable "domain_name" {
  description = "Public domain name (e.g. vayuprogdimloma.biz)"
  type        = string
  default     = ""
}

variable "github_repo" {
  description = "GitHub repo in owner/repo format — used to scope the OIDC deploy role"
  type        = string
}
