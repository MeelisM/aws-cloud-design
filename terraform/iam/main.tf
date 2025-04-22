# Centralized IAM permissions for infrastructure modules
# This file defines all the necessary permissions for the CLI admin user
# to work with VPC, EKS, ACM and Kubernetes-addons modules

# Get the CLI admin user data
data "aws_iam_user" "cli_admin" {
  user_name = var.cli_admin_username
}

# ----------------
# VPC Module Permissions
# ----------------

# VPC permissions based on verified working policy
resource "aws_iam_policy" "vpc_permissions" {
  name        = "VPCModulePermissions"
  description = "Policy allowing necessary permissions for VPC module operations"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "VisualEditor0",
        Effect = "Allow",
        Action = [
          "ec2:CreateVpc",
          "ec2:AllocateAddress",
          "ec2:CreateTags",
          "ec2:DescribeVpcs",
          "ec2:DescribeAddresses",
          "ec2:DescribeAddressesAttribute",
          "ec2:DescribeVpcAttribute",
          "ec2:DeleteVpc",
          "ec2:ReleaseAddress",
          "ec2:ModifyVpcAttribute",
          "ec2:CreateInternetGateway",
          "ec2:CreateSubnet",
          "ec2:DeleteSubnet",
          "ec2:AttachInternetGateway",
          "ec2:DescribeSubnets",
          "ec2:DescribeInternetGateways",
          "ec2:DeleteInternetGateway",
          "ec2:DescribeNetworkInterfaces",
          "ec2:ModifySubnetAttribute",
          "ec2:CreateRouteTable",
          "ec2:CreateNatGateway",
          "ec2:DescribeRouteTables",
          "ec2:DeleteRouteTable",
          "ec2:DescribeNatGateways",
          "ec2:DeleteNatGateway",
          "ec2:CreateRoute",
          "ec2:DetachInternetGateway",
          "ec2:DisassociateAddress",
          "ec2:AssociateRouteTable",
          "ec2:DisassociateRouteTable",
          "ec2:DescribeInstances",
          "ec2:DescribeVolumes",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeManagedPrefixLists",
          "ec2:DescribeSpotPriceHistory",
          "ec2:CreateSecurityGroup",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:DescribeRegions",
          "ec2:DescribeSnapshots",
          "ec2:DescribeImages",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:DescribeSecurityGroupRules",
          "ec2:RevokeSecurityGroupIngress"
        ],
        Resource = "*"
      }
    ]
  })
}

# ----------------
# EKS Module Permissions
# ----------------

resource "aws_iam_policy" "eks_permissions" {
  name        = "EKSModulePermissions"
  description = "Policy allowing necessary permissions for EKS module operations"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "VisualEditor0",
        Effect = "Allow",
        Action = [
          "eks:DescribeNodegroup",
          "eks:CreateCluster",
          "eks:DescribeCluster",
          "eks:TagResource",
          "eks:DeleteCluster",
          "eks:ListClusters",
          "eks:CreateNodegroup",
          "eks:DeleteNodegroup",
        ],
        Resource = "*"
      },
      {
        Sid    = "IAMForEKS",
        Effect = "Allow",
        Action = [
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:GetRole",
          "iam:PassRole",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:CreateServiceLinkedRole",
          "iam:CreateOpenIDConnectProvider",
          "iam:GetOpenIDConnectProvider",
          "iam:DeleteOpenIDConnectProvider",
          "iam:TagOpenIDConnectProvider",
          "iam:ListOpenIDConnectProviders",
          "iam:ListInstanceProfilesForRole"
        ],
        Resource = "*"
      },
      {
        Sid    = "AutoScalingForEKS",
        Effect = "Allow",
        Action = [
          "autoscaling:CreateAutoScalingGroup",
          "autoscaling:DeleteAutoScalingGroup",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:UpdateAutoScalingGroup"
        ],
        Resource = "*"
      }
    ]
  })
}

# ----------------
# ACM Module Permissions
# ----------------

resource "aws_iam_policy" "acm_permissions" {
  name        = "ACMModulePermissions"
  description = "Policy allowing necessary permissions for ACM module operations"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "VisualEditor0",
        Effect = "Allow",
        Action = [
          "acm:DescribeCertificate",
          "acm:ImportCertificate",
          "acm:AddTagsToCertificate",
          "acm:ListTagsForCertificate",
          "acm:DeleteCertificate",
          "acm:RequestCertificate",
          "acm:ListCertificates"
        ],
        Resource = "*"
      }
    ]
  })
}

# ----------------
# Tag Resources Permission
# ----------------

resource "aws_iam_policy" "tag_permissions" {
  name        = "TagResourcePermissions"
  description = "Policy allowing tag operations needed by various modules"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "VisualEditor0",
        Effect   = "Allow",
        Action   = "tag:GetResources",
        Resource = "*"
      }
    ]
  })
}

# ----------------
# CloudWatch Permission
# ----------------

resource "aws_iam_policy" "cloudwatch_permissions" {
  name        = "CloudWatchPermissions"
  description = "Policy allowing necessary permissions for CloudWatch module operations"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "CloudWatchDashboardPerms",
        Effect = "Allow",
        Action = [
          "cloudwatch:GetDashboard",
          "cloudwatch:DeleteDashboards",
          "cloudwatch:PutMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricData",
          "cloudwatch:PutDashboard",
          "cloudwatch:ListDashboards",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Resource = "*"
      },
      {
        Sid    = "EKSAddonPerms",
        Effect = "Allow",
        Action = [
          "eks:DescribeAddon",
          "eks:CreateAddon",
          "eks:DeleteAddon",
          "eks:UpdateAddon",
          "eks:ListAddons",
          "eks:DescribeCluster"
        ],
        Resource = "*"
      }
    ]
  })
}

# ----------------
# Policy Attachments
# ----------------

# Attach VPC policy to CLI admin user
resource "aws_iam_user_policy_attachment" "cli_admin_vpc" {
  user       = data.aws_iam_user.cli_admin.user_name
  policy_arn = aws_iam_policy.vpc_permissions.arn
}

# Attach EKS policy to CLI admin user
resource "aws_iam_user_policy_attachment" "cli_admin_eks" {
  user       = data.aws_iam_user.cli_admin.user_name
  policy_arn = aws_iam_policy.eks_permissions.arn
}

# Attach ACM policy to CLI admin user
resource "aws_iam_user_policy_attachment" "cli_admin_acm" {
  user       = data.aws_iam_user.cli_admin.user_name
  policy_arn = aws_iam_policy.acm_permissions.arn
}

# Attach Tag policy to CLI admin user
resource "aws_iam_user_policy_attachment" "cli_admin_tag" {
  user       = data.aws_iam_user.cli_admin.user_name
  policy_arn = aws_iam_policy.tag_permissions.arn
}

# Attach CloudWatch policy to CLI admin user
resource "aws_iam_user_policy_attachment" "cli_admin_cloudwatch" {
  user       = data.aws_iam_user.cli_admin.user_name
  policy_arn = aws_iam_policy.cloudwatch_permissions.arn
}

# ----------------
# Wait for IAM Policy Propagation
# ----------------

# Create a null resource that waits for IAM policies to propagate
resource "null_resource" "wait_for_iam_propagation" {
  depends_on = [
    aws_iam_user_policy_attachment.cli_admin_vpc,
    aws_iam_user_policy_attachment.cli_admin_eks,
    aws_iam_user_policy_attachment.cli_admin_acm,
    aws_iam_user_policy_attachment.cli_admin_tag,
    aws_iam_user_policy_attachment.cli_admin_cloudwatch
  ]

  provisioner "local-exec" {
    command = "echo 'IAM policies have been created. Waiting for 30 seconds for policy propagation...' && sleep 30"
  }
}

# Create another null resource to ensure IAM policies are destroyed last
resource "null_resource" "iam_destroyer" {
  provisioner "local-exec" {
    command = "echo 'All resources destroyed. Now will destroy IAM policies.'"
    when    = destroy
  }

  # This ensures the IAM policies are destroyed after all other resources
  depends_on = [
    null_resource.wait_for_iam_propagation
  ]
}
