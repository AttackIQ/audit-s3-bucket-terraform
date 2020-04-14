resource "aws_s3_bucket" "s3_bucket_audit_logs" {
  bucket = "${var.name}-s3-logs-${terraform.workspace}"
  acl    = "private"
}

resource "aws_s3_bucket_policy" "s3_bucket_audit_logs" {
  bucket = aws_s3_bucket.s3_bucket_audit_logs.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.s3_bucket_audit_logs.arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.s3_bucket_audit_logs.arn}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
  EOF
}
