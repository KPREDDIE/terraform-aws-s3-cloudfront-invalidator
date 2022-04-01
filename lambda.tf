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

data "aws_s3_bucket_object" "function_sha256" {
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
  source_code_hash = chomp(data.aws_s3_bucket_object.function_sha256.body)
  runtime          = "python3.9"
  timeout          = 3
  environment {
    variables = {
      BUCKET  = var.bucket_name
      CF_DIST = var.cloudfront_id
    }
  }
}

resource "aws_lambda_permission" "allow_rule" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.rule.arn
}
