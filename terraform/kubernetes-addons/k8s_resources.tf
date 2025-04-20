# Create a cluster role binding for the load balancer controller
resource "kubernetes_cluster_role_binding" "aws_load_balancer_controller" {
  metadata {
    name = "aws-load-balancer-controller"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "aws-load-balancer-controller"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
  }

  lifecycle {
    create_before_destroy = true
  }
}
