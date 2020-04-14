output "cloudtrail_log_group_arn" {
  value = aws_cloudwatch_log_group.s3_log_group.arn
}
