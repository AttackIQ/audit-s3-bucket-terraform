resource "aws_cloudwatch_log_group" "s3_log_group" {
  name = "${var.name}-s3-audit-logs-${var.workspace}"
}

resource "aws_cloudwatch_event_rule" "monitor_s3" {
  name        = "${var.name}_monitor_s3_bucket_${var.workspace}"
  description = "Monitors access to an S3 Bucket"

  event_pattern = <<EOF
{
  "source": [
    "aws.s3"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "s3.amazonaws.com"
    ],
    "eventName": [
      "GetObject",
      "PutObject"
    ],
    "requestParameters": {
      "bucketName": [
        "${var.monitored_s3_bucket}"
      ]
    }
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "trigger_lambda" {
    rule = aws_cloudwatch_event_rule.monitor_s3.name
    arn = var.lambda_function.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = var.lambda_function.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.monitor_s3.arn
}
