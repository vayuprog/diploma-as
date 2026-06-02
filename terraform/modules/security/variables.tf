variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "region" {
  type = string
}

variable "enable_guardduty" {
  description = "Enable GuardDuty (requires account subscription)"
  type        = bool
  default     = false
}
