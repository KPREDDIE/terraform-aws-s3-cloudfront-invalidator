variable "lambda_bucket" {
  type        = string
  default     = "ferdaus-uploads"
  description = "S3 bucket containing the module Lambda source code."
}

variable "lambda_key" {
  type        = string
  default     = "invalidator_function.zip"
  description = "The path to the Lambda ZIP file in the source S3 bucket."
}

variable "lambda_key_sha256" {
  type        = string
  default     = "invalidator_function.zip.sha256.txt"
  description = "The path to the Lambda ZIP file SHA256 hash in the source S3 bucket, generated using: openssl dgst -sha256 -binary invalidator_function.zip | openssl enc -base64 > invalidator_function.zip.sha256.txt"
}

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket hosting the web contents to refresh."
}

variable "bucket_arn" {
  type        = string
  description = "The ARN of the S3 bucket hosting the web contents to refresh."
}

variable "cloudfront_id" {
  type        = string
  description = "The ID of the CloudFront Distribution hosting the web contents to refresh."
}

variable "cloudfront_arn" {
  type        = string
  description = "The ARN of the CloudFront Distribution hosting the web contents to refresh."
}
