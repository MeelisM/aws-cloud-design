# IAM configuration for CLI admin user

# Variable to control whether to create these resources
variable "cli_admin_username" {
  description = "Username of the CLI admin user that needs S3 and DynamoDB permissions"
  type        = string
}

# Get the CLI admin user data
data "aws_iam_user" "cli_admin" {
  user_name = var.cli_admin_username
}

# S3 policy for bootstrap resources
resource "aws_iam_policy" "s3_bootstrap_policy" {
  name        = "S3BootstrapAccess"
  description = "Policy allowing S3 actions needed for Terraform state management"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "S3StateAccess",
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:GetBucketTagging",
          "s3:GetBucketPolicy",
          "s3:GetBucketAcl",
          "s3:GetBucketCors",
          "s3:GetBucketWebsite",
          "s3:GetBucketVersioning",
          "s3:PutBucketVersioning",
          "s3:GetBucketRequestPayment",
          "s3:GetBucketLogging",
          "s3:GetLifecycleConfiguration",
          "s3:GetReplicationConfiguration",
          "s3:GetEncryptionConfiguration",
          "s3:PutEncryptionConfiguration",
          "s3:GetBucketObjectLockConfiguration",
          "s3:PutBucketTagging",
          "s3:PutBucketPublicAccessBlock",
          "s3:GetBucketPublicAccessBlock",
          "s3:ListBucketVersions",
          "s3:DeleteObjectVersion",
          "s3:ListAllMyBuckets"
        ],
        Resource = "*"
      }
    ]
  })
}

# DynamoDB policy for bootstrap resources
resource "aws_iam_policy" "dynamodb_bootstrap_policy" {
  name        = "DynamoDBBootstrapAccess"
  description = "Policy allowing DynamoDB actions needed for Terraform state locking"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "DynamoDBStateAccess",
        Effect = "Allow",
        Action = [
          "dynamodb:CreateTable",
          "dynamodb:TagResource",
          "dynamodb:DescribeTable",
          "dynamodb:DescribeContinuousBackups",
          "dynamodb:DescribeTimeToLive",
          "dynamodb:ListTagsOfResource",
          "dynamodb:DeleteTable",
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:DeleteItem",
          "dynamodb:ListTables",
          "dynamodb:UpdateItem"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach S3 policy to CLI admin user
resource "aws_iam_user_policy_attachment" "cli_admin_s3" {
  user       = data.aws_iam_user.cli_admin.user_name
  policy_arn = aws_iam_policy.s3_bootstrap_policy.arn
}

# Attach DynamoDB policy to CLI admin user
resource "aws_iam_user_policy_attachment" "cli_admin_dynamodb" {
  user       = data.aws_iam_user.cli_admin.user_name
  policy_arn = aws_iam_policy.dynamodb_bootstrap_policy.arn
}
