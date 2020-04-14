resource "aws_lambda_function" "lambda" {
  filename      = "src/lambda_function_payload.zip"
  function_name = "${var.name}-LogS3DataEvents-${var.workspace}"
  role          = var.iam_role_arn 
  handler       = "lambda_function.lambda_handler"

  source_code_hash = "filebase64sha256(\"src/lambda_function_payload.zip\")"

  runtime = "python3.8"

  environment {
    variables = {
      email_topic = var.sns_topic_arn
    }
  }
}
