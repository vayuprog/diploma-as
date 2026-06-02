variable "name" {
  description = "Project name prefix"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.31"
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "node_sg_id" {
  description = "Security group ID for EKS worker nodes"
  type        = string
}

variable "allowed_cidr" {
  description = "CIDR allowed to reach the EKS public API endpoint (e.g. your home IP)"
  type        = string
}

variable "node_instance_type" {
  type    = string
  default = "t3.small"
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_max_size" {
  type    = number
  default = 3
}

variable "node_desired_size" {
  type    = number
  default = 1
}

variable "region" {
  type = string
}

variable "alb_sg_id" {
  description = "ALB security group ID — allowed to reach nodes on :3000"
  type        = string
}
