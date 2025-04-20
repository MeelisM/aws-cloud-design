output "metrics_server_status" {
  description = "Status of the Metrics Server deployment"
  value       = helm_release.metrics_server.status
}

output "aws_load_balancer_controller_status" {
  description = "Status of the AWS Load Balancer Controller deployment"
  value       = helm_release.aws_load_balancer_controller.status
}

output "aws_load_balancer_controller_role_arn" {
  description = "ARN of the IAM role used by the AWS Load Balancer Controller"
  value       = aws_iam_role.aws_load_balancer_controller.arn
}

output "kubernetes_addons_info" {
  description = "Information about installed Kubernetes add-ons"
  value = {
    metrics_server = {
      version   = var.metrics_server_chart_version
      namespace = "kube-system"
    }
    aws_load_balancer_controller = {
      version   = var.aws_lb_controller_chart_version
      namespace = "kube-system"
    }
  }
}
