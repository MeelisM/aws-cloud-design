resource "aws_cloudwatch_dashboard" "eks_monitoring_dashboard" {
  dashboard_name = "${var.cluster_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["ContainerInsights", "pod_cpu_utilization", "ClusterName", var.cluster_name, { "region" : var.aws_region }]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Overall Pod CPU Utilization"
          view   = "timeSeries"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["ContainerInsights", "pod_memory_utilization", "ClusterName", var.cluster_name, { "region" : var.aws_region }]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Overall Pod Memory Utilization"
          view   = "timeSeries"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["ContainerInsights", "pod_cpu_utilization", "ClusterName", var.cluster_name, "Namespace", "default", { "region" : var.aws_region }],
            ["ContainerInsights", "pod_cpu_utilization", "ClusterName", var.cluster_name, "Namespace", "kube-system", { "region" : var.aws_region }]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "CPU Utilization by Namespace"
          view   = "timeSeries"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["ContainerInsights", "pod_memory_utilization", "ClusterName", var.cluster_name, "Namespace", "default", { "region" : var.aws_region }],
            ["ContainerInsights", "pod_memory_utilization", "ClusterName", var.cluster_name, "Namespace", "kube-system", { "region" : var.aws_region }]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Memory Utilization by Namespace"
          view   = "timeSeries"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["ContainerInsights", "pod_cpu_utilization",
              "PodName", "api-gateway-app",
              "ClusterName", var.cluster_name,
              "Namespace", "default",
            { "region" : var.aws_region }],
            ["...", "inventory-app",
              ".", ".",
              ".", ".",
            { "region" : var.aws_region }],
            ["...", "billing-app-0",
              ".", ".",
              ".", ".",
            { "region" : var.aws_region }]
          ],
          view : "timeSeries",
          stacked : false,
          region : var.aws_region,
          title : "Application CPU Utilization by Pod",
          period : 300
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 12
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["ContainerInsights", "pod_memory_utilization",
              "PodName", "api-gateway-app",
              "ClusterName", var.cluster_name,
              "Namespace", "default",
            { "region" : var.aws_region }],
            ["...", "inventory-app",
              ".", ".",
              ".", ".",
            { "region" : var.aws_region }],
            ["...", "billing-app-0",
              ".", ".",
              ".", ".",
            { "region" : var.aws_region }]
          ],
          view : "timeSeries",
          stacked : false,
          region : var.aws_region,
          title : "Application Memory Utilization by Pod",
          period : 300
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 18
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["ContainerInsights", "pod_cpu_utilization",
              "PodName", "inventory-db-0",
              "ClusterName", var.cluster_name,
              "Namespace", "default",
            { "region" : var.aws_region }],
            ["...", "billing-db-0",
              ".", ".",
              ".", ".",
            { "region" : var.aws_region }],
            ["...", "billing-queue-0",
              ".", ".",
              ".", ".",
            { "region" : var.aws_region }]
          ],
          view : "timeSeries",
          stacked : false,
          region : var.aws_region,
          title : "Infrastructure CPU Utilization by Pod",
          period : 300
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 18
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["ContainerInsights", "pod_memory_utilization",
              "PodName", "inventory-db-0",
              "ClusterName", var.cluster_name,
              "Namespace", "default",
            { "region" : var.aws_region }],
            ["...", "billing-db-0",
              ".", ".",
              ".", ".",
            { "region" : var.aws_region }],
            ["...", "billing-queue-0",
              ".", ".",
              ".", ".",
            { "region" : var.aws_region }]
          ],
          view : "timeSeries",
          stacked : false,
          region : var.aws_region,
          title : "Infrastructure Memory Utilization by Pod",
          period : 300
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 24
        width  = 24
        height = 6
        properties = {
          metrics = [
            ["ContainerInsights", "node_cpu_utilization", "ClusterName", var.cluster_name, { "region" : var.aws_region }]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Node CPU Utilization"
          view   = "timeSeries"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 30
        width  = 24
        height = 6
        properties = {
          metrics = [
            ["ContainerInsights", "node_memory_utilization", "ClusterName", var.cluster_name, { "region" : var.aws_region }]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Node Memory Utilization"
          view   = "timeSeries"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 36
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["ContainerInsights", "container_cpu_utilization",
              "PodName", "api-gateway-app",
              "ContainerName", "api-gateway",
              "ClusterName", var.cluster_name,
              "Namespace", "default",
            { "region" : var.aws_region }],
            ["...", "inventory-app",
              ".", "inventory-app",
              ".", ".",
              ".", ".",
            { "region" : var.aws_region }],
            ["...", "billing-app-0",
              ".", "billing-app",
              ".", ".",
              ".", ".",
            { "region" : var.aws_region }]
          ],
          view : "timeSeries",
          stacked : false,
          region : var.aws_region,
          title : "Container CPU Utilization",
          period : 300
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 36
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["ContainerInsights", "container_memory_utilization",
              "PodName", "api-gateway-app",
              "ContainerName", "api-gateway",
              "ClusterName", var.cluster_name,
              "Namespace", "default",
            { "region" : var.aws_region }],
            ["...", "inventory-app",
              ".", "inventory-app",
              ".", ".",
              ".", ".",
            { "region" : var.aws_region }],
            ["...", "billing-app-0",
              ".", "billing-app",
              ".", ".",
              ".", ".",
            { "region" : var.aws_region }]
          ],
          view : "timeSeries",
          stacked : false,
          region : var.aws_region,
          title : "Container Memory Utilization",
          period : 300
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 42
        width  = 24
        height = 6
        properties = {
          metrics = [
            ["ContainerInsights", "pod_cpu_utilization_over_pod_limit",
              "PodName", "api-gateway-app",
              "ClusterName", var.cluster_name,
              "Namespace", "default",
            { "region" : var.aws_region }],
            ["...", "inventory-app",
              ".", ".",
              ".", ".",
            { "region" : var.aws_region }],
            ["...", "billing-app-0",
              ".", ".",
              ".", ".",
            { "region" : var.aws_region }],
            [".", "pod_memory_utilization_over_pod_limit",
              ".", "api-gateway-app",
              ".", ".",
              ".", ".",
            { "region" : var.aws_region }],
            ["...", "inventory-app",
              ".", ".",
              ".", ".",
            { "region" : var.aws_region }],
            ["...", "billing-app-0",
              ".", ".",
              ".", ".",
            { "region" : var.aws_region }]
          ],
          view : "timeSeries",
          stacked : false,
          region : var.aws_region,
          title : "Resource Utilization Over Limits",
          period : 300
        }
      }
    ]
  })
}

# Enable CloudWatch Container Insights on the EKS cluster
resource "aws_eks_addon" "container_insights" {
  cluster_name                = var.cluster_name
  addon_name                  = "amazon-cloudwatch-observability"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = {
    Environment = var.environment
  }
}
