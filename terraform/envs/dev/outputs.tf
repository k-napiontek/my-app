output "ecr_repository_url" {
  value       = module.ecr.repository_url
  description = "ECR repository URL for docker push"
}

output "ecr_repository_name" {
  value       = module.ecr.repository_name
  description = "ECR repository name (use in GitHub Actions ECR_REPOSITORY secret)"
}

output "github_role_arn" {
  value       = module.ecr.github_role_arn
  description = "IAM role ARN for GitHub Actions (use in AWS_ROLE_ARN secret)"
}
