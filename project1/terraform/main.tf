provider "aws" {
  region = var.region
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name = "project1-main-lambda"

  # 👇 Use an existing IAM role from the same AWS account (replace this)
  role          = "arn:aws:iam::339713042546:role/project1-lambda-exec-role"

  handler       = "index.handler"
  runtime       = "nodejs18.x"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}