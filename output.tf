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
