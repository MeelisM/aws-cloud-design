# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

# EKS Outputs
output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "nodes_security_group_id" {
  description = "Security group ID attached to the EKS nodes"
  value       = module.eks.nodes_security_group_id
}

output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN associated with EKS cluster"
  value       = module.eks.cluster_iam_role_arn
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  value       = module.eks.oidc_provider_arn
}

output "kubectl_config_command" {
  description = "Command to update kubeconfig to connect to the EKS cluster"
  value       = module.eks.kubectl_config_command
}

output "aws_load_balancer_controller_policy_arn" {
  description = "AWS Load Balancer Controller IAM Policy ARN"
  value       = module.eks.aws_load_balancer_controller_policy_arn
}

output "cluster_autoscaler_policy_arn" {
  description = "Cluster Autoscaler IAM Policy ARN"
  value       = module.eks.cluster_autoscaler_policy_arn
}

# ACM Certificate Outputs
output "certificate_arn" {
  description = "The ARN of the SSL/TLS certificate"
  value       = module.acm.certificate_arn
}

output "certificate_status" {
  description = "Status of the certificate"
  value       = module.acm.certificate_status
}

output "certificate_common_name" {
  description = "Common name used for the self-signed certificate"
  value       = var.certificate_common_name
}
