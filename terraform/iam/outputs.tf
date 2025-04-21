output "iam_policy_readiness" {
  description = "Output to indicate when IAM policies have been created and the waiting period is complete"
  value       = null_resource.wait_for_iam_propagation.id
}
