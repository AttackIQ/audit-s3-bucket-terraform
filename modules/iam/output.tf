output "cloudtrail_role_arn" {
  value = aws_iam_role.cloudtrail_role.arn
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}
