locals {
  # GitHub OIDC subject - format: repo:owner/repo:ref:refs/heads/branch
  github_subject = "repo:${var.github_repo}:ref:refs/heads/*"
}

module "ecr" {
  source = "terraform-aws-modules/ecr/aws"
  version = "~> 3.0"

  repository_name = var.repository_name

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = var.tags
}

module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 5.0"

  name        = "${var.repository_name}-github-ecr-push"
  path        = "/"
  description = "Allow GitHub Actions to push to ECR repository ${var.repository_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = ["*"]
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Resource = [module.ecr.repository_arn]
      },
    ]
  })
}

module "iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"
  version = "~> 5.0"

  name = "${var.repository_name}-github-actions"

  subjects = [local.github_subject]

  policies = {
    ECRPush = module.iam_policy.arn
  }

  tags = var.tags
}