variable "allowed_ips" {
  description = "allowed IP adresses for VPC security group"
  # sensitive = true
}

variable "role_arn" {
  description = "The ARN of the role to assume"
  sensitive   = true
}
