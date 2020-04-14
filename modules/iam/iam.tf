resource "aws_iam_role" "cloudtrail_role" {
  name = "${var.name}_CloudTrail_role_${var.workspace}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  EOF
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.name}_Lambda_role_${var.workspace}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  EOF
}

resource "aws_iam_policy" "cloudtrail_log_group_policy" {
  name = "${var.name}-cloudwatch-logs-policy-${var.workspace}"
  description = "This policy allows to add new logs into a LogGroup"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailPutLogEvents20141101",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
  EOF
}

resource "aws_iam_policy" "lambda_execution_policy" {
  name = "${var.name}-lambda-execution-policy-${var.workspace}"
  description = "This policy allows add logs to the LogGroup and to publish to SNS topic"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SNSPublish",
            "Effect": "Allow",
            "Action": [
                "sns:Publish"
            ],
            "Resource": [
                "${var.sns_topic}"
            ]
        },
        {
            "Sid": "LambdaExecutionLogs",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:CreateLogGroup",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
  EOF
}

resource "aws_iam_policy_attachment" "role-policy-attachment" {
  name = "${var.name}-role-policy-attachment-${var.workspace}"
  roles = [aws_iam_role.cloudtrail_role.name]
  policy_arn = aws_iam_policy.cloudtrail_log_group_policy.arn
}

resource "aws_iam_policy_attachment" "lambda-role-policy-attachment" {
  name = "${var.name}-lambda-role-policy-attachment-${var.workspace}"
  roles = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
}
