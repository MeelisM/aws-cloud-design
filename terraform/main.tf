# IAM module for centralized policy management
# This must be created first during apply and destroyed last during destroy
module "iam" {
  source = "./iam"

  aws_region         = var.aws_region
  environment        = var.environment
  cli_admin_username = var.cli_admin_username
}

module "vpc" {
  source = "./vpc"

  aws_region           = var.aws_region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  cluster_name         = var.cluster_name

  # Make VPC module depend on IAM policies with propagation delay
  depends_on = [module.iam.iam_policy_readiness]
}

module "eks" {
  source = "./eks"

  aws_region         = var.aws_region
  environment        = var.environment
  cluster_name       = var.cluster_name
  kubernetes_version = var.cluster_version
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  # Node group configuration
  node_instance_types = var.node_instance_types
  capacity_type       = var.capacity_type
  desired_capacity    = var.desired_capacity
  min_capacity        = var.min_capacity
  max_capacity        = var.max_capacity

  # Make EKS module depend on IAM policies with propagation delay
  depends_on = [module.iam.iam_policy_readiness, module.vpc]
}

# AWS Certificate Manager for HTTPS (self-signed certificate for demo)
module "acm" {
  source = "./acm"

  aws_region              = var.aws_region
  environment             = var.environment
  certificate_common_name = var.certificate_common_name

  # Make ACM module depend on IAM policies with propagation delay
  depends_on = [module.iam.iam_policy_readiness]
}

module "kubernetes_addons" {
  source = "./kubernetes-addons"

  aws_region            = var.aws_region
  cluster_name          = var.cluster_name
  eks_oidc_provider_arn = module.eks.oidc_provider_arn
  eks_oidc_provider_url = module.eks.oidc_provider_url
  vpc_id                = module.vpc.vpc_id

  aws_lb_controller_chart_version = "1.6.2"
  metrics_server_chart_version    = "3.11.0"
  create_custom_lb_policy         = true

  depends_on = [module.iam.iam_policy_readiness, module.eks]
}

# CloudWatch dashboard for EKS monitoring
module "cloudwatch_dashboard" {
  source = "./cloudwatch"

  aws_region            = var.aws_region
  environment           = var.environment
  cluster_name          = var.cluster_name
  eks_oidc_provider_arn = module.eks.oidc_provider_arn
  eks_oidc_provider_url = module.eks.oidc_provider_url

  depends_on = [module.eks]
}
