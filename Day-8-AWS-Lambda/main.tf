terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.7"
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "lambda.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "my-lambda" {
function_name = "lambda"
runtime = "python3.14"
role = aws_iam_role.lambda_role.arn
handler = "lambda_function.lambda_handler"
filename = "lambda_function.zip"
timeout = 300
memory_size = 128
source_code_hash = filebase64sha256("lambda_function.zip")
}

resource "aws_cloudwatch_event_rule" "lambda_schedule" {
  name                = "lambda_schedule_rule"
  description         = "Trigger Lambda on a schedule"
  schedule_expression = "cron(0/5 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "lambda_schedule_target" {
  rule      = aws_cloudwatch_event_rule.lambda_schedule.name
  target_id = "lambda_schedule_target"
  arn       = aws_lambda_function.my-lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my-lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_schedule.arn
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my-lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.lambda_bucket.arn
}


resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "rghilhsdjkvb"

  tags = {
    Name = "Lambda Code Bucket"
  }

}

resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda_function.zip"
  source = data.archive_file.lambda_zip.output_path
  etag   = filemd5(data.archive_file.lambda_zip.output_path)
}