variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-north-1"
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "certificate_common_name" {
  description = "Common name for the self-signed certificate (can be any value for demo)"
  type        = string
  default     = "cloudproject.example.com"
}
