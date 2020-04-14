resource "aws_cloudtrail" "s3-audit-trail" {
  count                         = 1
  name                          = "${var.name}-trail-logs-${var.workspace}"
  s3_bucket_name                = "${var.name}-s3-logs-${var.workspace}"
  s3_key_prefix                 = "s3-monitoring-logs"
  cloud_watch_logs_role_arn     = var.iam_role_arn
  cloud_watch_logs_group_arn    = var.log_group_arn
  enable_logging                = true
  is_multi_region_trail         = false
  is_organization_trail         = false
  enable_log_file_validation    = false
  event_selector {
    read_write_type             = "All"
    include_management_events   = true
    data_resource {
      type = "AWS::S3::Object"
      values = ["${var.monitored_s3_bucket_arn}/"]
    }
  }
}
