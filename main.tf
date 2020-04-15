data "aws_s3_bucket" "monitored_bucket" {
  bucket = var.monitored_bucket
}

module "iam" {
  source = "./modules/iam"
  name = var.name
  workspace = terraform.workspace
  sns_topic = module.sns.sns_topic_arn 
}

module "s3" {
  source = "./modules/s3"
  name = var.name
  workspace = terraform.workspace
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
  name = var.name
  workspace = terraform.workspace
  monitored_s3_bucket = data.aws_s3_bucket.monitored_bucket.bucket
  lambda_function = module.lambda.lambda_function
}

module "cloudtrail" {
  source = "./modules/cloudtrail"
  name = var.name
  workspace = terraform.workspace
  iam_role_arn = module.iam.cloudtrail_role_arn
  log_group_arn = module.cloudwatch.cloudtrail_log_group_arn
  monitored_s3_bucket_arn = data.aws_s3_bucket.monitored_bucket.arn
  depends_on_ = [ 
    module.s3.s3_bucket_policy_id
  ]
}

module "sns" {
  source = "./modules/sns"
  name = var.name
  workspace = terraform.workspace
  monitored_s3_bucket = "${data.aws_s3_bucket.monitored_bucket.bucket}"
}

module "lambda" {
  source = "./modules/lambda"
  name = var.name
  workspace = terraform.workspace
  iam_role_arn = module.iam.lambda_role_arn
  sns_topic_arn = module.sns.sns_topic_arn
}
