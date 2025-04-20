# Bootstrap module for Terraform backend infrastructure
# This module creates the necessary infrastructure for storing Terraform state remotely
# and enabling state locking for collaborative work.
#
# The actual resources are defined in:
# - s3.tf: S3 bucket for state storage with appropriate configurations
# - dynamodb.tf: DynamoDB table for state locking
# - providers.tf: AWS provider configuration
