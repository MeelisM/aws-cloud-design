variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "cli_admin_username" {
  description = "Username of the CLI admin user that needs AWS permissions"
  type        = string
}
