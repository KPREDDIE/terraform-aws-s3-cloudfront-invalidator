resource "aws_iam_role" "role" {
  name                = "${var.bucket_name}EventDetectionLambda"
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
  assume_role_policy  = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
  inline_policy {
    name = "${var.bucket_name}EventDetectionLambda"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:Get*",
            "s3:List*"
          ]
          Effect = "Allow"
          Resource = [
            var.bucket_arn,
            "${var.bucket_arn}/*"
          ]
        },
        {
          Action = [
            "cloudfront:CreateInvalidation"
          ]
          Effect = "Allow"
          Resource = [
            var.cloudfront_arn
          ]
        }
      ]
    })
  }
}

data "aws_s3_object" "function_sha256" {
  bucket = var.lambda_bucket
  key    = var.lambda_key_sha256
}

resource "aws_lambda_function" "function" {
  architectures    = ["arm64"]
  s3_bucket        = var.lambda_bucket
  s3_key           = var.lambda_key
  function_name    = "${var.bucket_name}EventDetectionLambda"
  role             = aws_iam_role.role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = chomp(data.aws_s3_object.function_sha256.body)
  runtime          = "python3.9"
  timeout          = 3
  environment {
    variables = {
      CFDIST = var.cloudfront_id
    }
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.bucket_arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.function.arn
    events              = [
      "s3:ObjectCreated:*",
      "s3:ObjectRemoved:*"
    ]
    /* filter_prefix       = "AWSLogs/"
    filter_suffix       = ".log" */
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}
