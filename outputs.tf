output "lambda_function" {
  value       = aws_lambda_function.function.function_name
  description = "The name of the CloudFront cache invalidation Lambda function."
}
