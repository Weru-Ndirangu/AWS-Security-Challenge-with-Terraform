output "public_dns" {
  value = aws_lb.frontend_lb.dns_name
}

# Output the CloudFront distribution domain name
output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.cdn.domain_name
  description = "The domain name of the CloudFront distribution"
}

# Output the CloudFront distribution ID
output "cloudfront_distribution_id" {
  value       = aws_cloudfront_distribution.cdn.id
  description = "The ID of the CloudFront distribution"
}

# Outputs for  S3 bucket details
output "s3_bucket_name" {
  value       = aws_s3_bucket.cloudfront_trail_bucket.bucket
  description = "S3 bucket for CloudFront logs"
}

#CloudTrail details
output "cloudtrail_arn" {
  value       = aws_cloudtrail.cloudfront_trail.arn
  description = "The ARN of the CloudTrail for CloudFront"
}
