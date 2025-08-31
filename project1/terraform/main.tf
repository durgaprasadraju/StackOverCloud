provider "aws" {
  region = "us-east-1"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name = "project1-main-lambda"

  # ✅ Use existing role — no need for iam:PassRole
  role          = "arn:aws:iam::339713042546:role/service-role/project1-main-lambda-role-24j7xw1e"

  handler       = "index.handler"
  runtime       = "nodejs22.x"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  # ✅ Do NOT set publish or log retention
  lifecycle {
    ignore_changes = [role]
  }
}
