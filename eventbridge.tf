resource "aws_cloudwatch_event_rule" "rule" {
  name        = "capture-s3-put-delete"
  description = "Capture S3 PUT and DELETE object events."

  event_pattern = <<EOF
{
    "source": [
        "aws.s3"
    ],
    "detail-type": [
        "Object Created",
        "Object Deleted"
    ],

    "detail": {
        "bucket": {
            "name": [
                "${var.bucket_name}"
            ]
        }
    }
}
EOF
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.rule.name
  target_id = "InvokeLambdaFunction"
  arn       = aws_lambda_function.function.arn
  input_transformer {
    input_paths = {
      bucket = "$.detail.bucket.name"
      key    = "$.detail.object.key"
    }
    input_template = <<EOF
{"bucket": <bucket>, "key": <key>}
EOF
  }
}
