# terraform-aws-s3-cloudfront-invalidator

Automated CloudFront Distribution cache invalidation using Lambda and EventBridge.

## Overview

This is a basic module which allows you to invalidate CloudFront cache for objects served from an S3 bucket. It uses EventBridge to detect PUT and DELETE events from S3, and triggers a Lambda function which executes the invalidation task.
