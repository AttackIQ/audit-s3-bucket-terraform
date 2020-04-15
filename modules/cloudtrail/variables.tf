variable "name" {}
variable "workspace" {}
variable "iam_role_arn" {}
variable "log_group_arn" {}
variable "monitored_s3_bucket_arn" {}
variable "depends_on_" {
  default = []
  type = list(string) 
}
