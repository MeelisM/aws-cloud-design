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

# CloudWatch Dashboard Outputs
output "cloudwatch_dashboard_name" {
  description = "Name of the CloudWatch Dashboard monitoring EKS"
  value       = module.cloudwatch_dashboard.dashboard_name
}

output "cloudwatch_dashboard_arn" {
  description = "ARN of the CloudWatch Dashboard"
  value       = module.cloudwatch_dashboard.dashboard_arn
}

output "container_insights_addon_name" {
  description = "Name of the Container Insights EKS addon"
  value       = module.cloudwatch_dashboard.container_insights_addon_name
}

output "container_insights_addon_version" {
  description = "Version of the Container Insights EKS addon"
  value       = module.cloudwatch_dashboard.container_insights_addon_version
}

output "cloudwatch_agent_role_arn" {
  description = "ARN of the IAM role used by CloudWatch agent"
  value       = module.cloudwatch_dashboard.cloudwatch_agent_role_arn
}

# API Gateway Ingress Outputs
output "api_gateway_ingress_manifest" {
  description = "Path to the generated API Gateway ingress manifest"
  value       = local_file.api_gateway_ingress.filename
}

output "next_steps" {
  description = "Instructions for next steps after Terraform apply"
  value       = <<-EOT
    ✅ Infrastructure successfully deployed!
    
    Next steps:
    1. Configure kubectl and Helm to connect to your EKS cluster:
       cd .. && ./scripts/configure-kubectl-helm.sh
       
    2. Apply the Kubernetes manifests:
       kubectl apply -k .  # Apply using kustomization
    
    Run the following command to check the status of your ingress:
    kubectl get ingress

    #############################################

    Before destroying the infrastructure, ensure to clean up any resources created in the cluster with:
    ./scripts/cleanup-k8s-resources.sh
    It might take a few minutes to remove all resources.

    To destroy the infrastructure, run the command in terraform directory:
    terraform destroy -auto-approve
    This will remove all resources created by this Terraform configuration.

    After destroying the main infrastructure, be sure to delete the bootstrap infrastructure as well.
    Go to the bootstrap directory and run:
    terraform destroy -auto-approve
    This will remove all resources created by the bootstrap setup.
  EOT
}
