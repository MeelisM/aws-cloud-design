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

  set {
    name  = "args[0]"
    value = "--cert-dir=/tmp"
  }

  set {
    name  = "args[1]"
    value = "--secure-port=10443"
  }

  set {
    name  = "args[2]"
    value = "--kubelet-preferred-address-types=InternalIP"
  }

  set {
    name  = "args[3]"
    value = "--kubelet-use-node-status-port"
  }

  set {
    name  = "args[4]"
    value = "--metric-resolution=15s"
  }

  set {
    name  = "args[5]"
    value = "--kubelet-insecure-tls=true"
  }

  set {
    name  = "hostNetwork.enabled"
    value = true
  }

  set {
    name  = "resources.requests.cpu"
    value = "50m"
  }

  set {
    name  = "resources.requests.memory"
    value = "64Mi"
  }

  depends_on = [
    helm_release.aws_load_balancer_controller
  ]
}
