variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "eks_oidc_provider_arn" {
  description = "ARN of the OIDC provider associated with the EKS cluster"
  type        = string
}

variable "eks_oidc_provider_url" {
  description = "URL of the OIDC provider associated with the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster is deployed"
  type        = string
}

variable "aws_lb_controller_chart_version" {
  description = "Version of the AWS Load Balancer Controller Helm chart"
  type        = string
  default     = "1.6.2"
}

variable "metrics_server_chart_version" {
  description = "Version of the Metrics Server Helm chart"
  type        = string
  default     = "3.11.0"
}

variable "create_custom_lb_policy" {
  description = "Whether to create a custom IAM policy for the AWS Load Balancer Controller"
  type        = bool
  default     = false
}
