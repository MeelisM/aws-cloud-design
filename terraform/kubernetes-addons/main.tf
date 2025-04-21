locals {
  aws_region = var.aws_region
}

# Install AWS Load Balancer Controller using Helm
resource "helm_release" "aws_load_balancer_controller" {
  name             = "aws-load-balancer-controller"
  namespace        = "kube-system"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  version          = var.aws_lb_controller_chart_version
  create_namespace = false
  atomic           = true

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = true
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.aws_load_balancer_controller.arn
  }

  set {
    name  = "region"
    value = local.aws_region
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  depends_on = [
    aws_iam_role_policy_attachment.aws_load_balancer_controller
  ]
}

resource "helm_release" "metrics_server" {
  name             = "metrics-server"
  namespace        = "kube-system"
  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  chart            = "metrics-server"
  version          = var.metrics_server_chart_version
  create_namespace = false
  atomic           = false
  timeout          = 900
  wait             = false
  force_update     = true
  replace          = true

  # Use values yaml to override arguments instead of individual set blocks
  # This prevents duplicate arguments that were causing the CrashLoopBackOff
  values = [
    <<-EOT
    args:
      - --cert-dir=/tmp
      - --secure-port=10443
      - --kubelet-preferred-address-types=InternalIP
      - --kubelet-use-node-status-port
      - --metric-resolution=15s
      - --kubelet-insecure-tls=true
    hostNetwork:
      enabled: true
    resources:
      requests:
        cpu: "50m"
        memory: "64Mi"
    livenessProbe:
      httpGet:
        path: /livez
        port: 10443
        scheme: HTTPS
    readinessProbe:
      httpGet:
        path: /readyz
        port: 10443
        scheme: HTTPS
    EOT
  ]

  depends_on = [
    helm_release.aws_load_balancer_controller
  ]
}
