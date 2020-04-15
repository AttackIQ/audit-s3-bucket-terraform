output "bucket_name" {
  value = aws_s3_bucket.s3_bucket_audit_logs.id
}

output "s3_bucket_policy_id" {
  value = aws_s3_bucket_policy.s3_bucket_audit_logs.id
}
