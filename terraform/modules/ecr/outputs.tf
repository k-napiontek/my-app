output "repository_url" {
  value       = module.ecr.repository_url
  description = "URL of the ECR repository"
}

output "repository_name" {
  value       = module.ecr.repository_name
  description = "Name of the ECR repository"
}

output "repository_arn" {
  value       = module.ecr.repository_arn
  description = "ARN of the ECR repository"
}

output "github_role_arn" {
  value       = module.iam_role.arn
  description = "ARN of the IAM role for GitHub Actions (use in role-to-assume)"
}
