output "ebs_encryption_by_default" {
  description = "The updated status of encryption by default"
  value       = data.aws_ebs_encryption_by_default.current.enabled
}

output "cluster_endpoint" {
  value       = "alias/aws/ebs"
  description = "KMS Key Id"
}

