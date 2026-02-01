variable "repository_name" {
  type        = string
  description = "Name of the ECR repository"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository in format owner/repo (e.g. myorg/project-1.02.2026)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for all resources"
}