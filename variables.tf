data "aws_caller_identity" "current" {}
locals {
  account_id = data.aws_caller_identity.current.account_id
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Working region."
}

variable "tag_Name" {
  type        = string
  description = "Human-friendly name for the project resources."
}

variable "tag_sitecode" {
  type        = string
  description = "Which site the project is attached to."
}

variable "tag_department" {
  type        = string
  description = "Which department owns the project."
}

variable "tag_team" {
  type        = string
  description = "Which team owns the project."
}

variable "tag_tier" {
  type        = string
  description = "Deployment tier for the resources."
}

variable "tag_costcenter" {
  type        = string
  description = "Which cost center the project is attached to."
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
