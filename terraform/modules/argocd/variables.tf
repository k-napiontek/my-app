variable "cluster_name" {
  type        = string
  description = "EKS cluster name (for IAM role name and Pod Identity association)"
}

variable "ecr_repository_arn" {
  type        = string
  default     = null
  description = "ARN of ECR repository for Image Updater (ecr:DescribeImages, ecr:ListImages). If null, only AmazonEC2ContainerRegistryReadOnly is attached."
}
