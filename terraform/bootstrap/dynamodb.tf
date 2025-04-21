resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"

  # Add explicit dependency on IAM policies
  depends_on = [null_resource.wait_for_iam]

  attribute {
    name = "LockID"
    type = "S"
  }

  hash_key = "LockID"

  tags = {
    Name        = "Terraform State Lock Table"
    Environment = var.environment
  }
}
