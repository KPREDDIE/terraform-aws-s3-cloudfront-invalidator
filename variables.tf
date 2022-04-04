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
