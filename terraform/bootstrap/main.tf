# Bootstrap module for Terraform backend infrastructure
# This module creates the necessary infrastructure for storing Terraform state remotely
# and enabling state locking for collaborative work.
#
# The actual resources are defined in:
# - s3.tf: S3 bucket for state storage with appropriate configurations
# - dynamodb.tf: DynamoDB table for state locking
# - providers.tf: AWS provider configuration
resource "null_resource" "wait_for_iam" {
  depends_on = [
    aws_iam_user_policy_attachment.cli_admin_s3,
    aws_iam_user_policy_attachment.cli_admin_dynamodb
  ]

  provisioner "local-exec" {
    command = "sleep 10"
  }
}
