output "dashboard_arn" {
  description = "ARN of the CloudWatch Dashboard for EKS monitoring"
  value       = aws_cloudwatch_dashboard.eks_monitoring_dashboard.dashboard_arn
}

output "dashboard_name" {
  description = "Name of the CloudWatch Dashboard"
  value       = aws_cloudwatch_dashboard.eks_monitoring_dashboard.dashboard_name
}

output "container_insights_addon_name" {
  description = "Name of the Container Insights EKS addon"
  value       = aws_eks_addon.container_insights.addon_name
}

output "container_insights_addon_version" {
  description = "Version of the Container Insights EKS addon"
  value       = aws_eks_addon.container_insights.addon_version
}

output "cloudwatch_agent_role_arn" {
  description = "ARN of the IAM role used by CloudWatch agent"
  value       = aws_iam_role.cloudwatch_agent.arn
}
