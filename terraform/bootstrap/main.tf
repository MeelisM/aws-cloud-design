# Bootstrap module for Terraform backend infrastructure
# This module creates the necessary infrastructure for storing Terraform state remotely
# and enabling state locking for collaborative work.
#
# The actual resources are defined in:
# - s3.tf: S3 bucket for state storage with appropriate configurations
# - dynamodb.tf: DynamoDB table for state locking
# - providers.tf: AWS provider configuration

# Create a null resource that ensures IAM policies are created first
resource "null_resource" "wait_for_iam" {
  depends_on = [
    aws_iam_user_policy_attachment.cli_admin_s3,
    aws_iam_user_policy_attachment.cli_admin_dynamodb
  ]

  provisioner "local-exec" {
    command = "echo 'IAM policies have been created. Waiting for 10 seconds for policy propagation...' && sleep 10"
  }
}

# Create another null resource to ensure IAM policies are destroyed last
resource "null_resource" "iam_destroyer" {
  # This resource doesn't depend on anything explicitly in the code
  # But all other resources will depend on the wait_for_iam resource
  # which means this will be destroyed first, before any dependent resources

  provisioner "local-exec" {
    command = "echo 'All resources destroyed. Now will destroy IAM policies.'"
    when    = destroy
  }

  depends_on = [
    aws_s3_bucket.terraform_state,
    aws_dynamodb_table.terraform_locks
  ]
}
