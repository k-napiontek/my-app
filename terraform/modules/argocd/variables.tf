variable "cluster_name" {
  type        = string
  description = "EKS cluster name (for IAM role name and Pod Identity association)"
}

variable "ecr_repository_arn" {
  type        = string
  default     = null
  description = "ARN of ECR repository for Image Updater (ecr:DescribeImages, ecr:ListImages). If null, only AmazonEC2ContainerRegistryReadOnly is attached."
}

variable "app_of_apps_repo_url" {
  type        = string
  description = "Git repo URL for the root Application (app-of-apps)"
}

variable "app_of_apps_path" {
  type        = string
  default     = "argocd/apps"
  description = "Path in the repo where Application manifests are"
}

variable "app_of_apps_target_revision" {
  type        = string
  default     = "main"
  description = "Branch/tag for the app-of-apps repo"
}