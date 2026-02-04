resource "helm_release" "argocd" {
  name = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"
  namespace = "argocd"
  create_namespace = true
  version = "9.3.7"

  values = [
    file("${path.module}/values.yaml")
  ]

}

resource "helm_release" "updater" {
  name = "updater"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-image-updater"
  namespace        = "argocd"
  create_namespace = true
  version          = "1.0.5"

  values = [file("${path.module}/image-updater.yaml")]

  depends_on = [
    aws_iam_role.argocd_image_updater,
    aws_iam_role_policy_attachment.argocd_image_updater,
    aws_eks_pod_identity_association.argocd_image_updater
  ]
}

data "aws_iam_policy_document" "argocd_image_updater" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "argocd_image_updater" {
  name               = "${var.cluster_name}-argocd-image-updater"
  assume_role_policy = data.aws_iam_policy_document.argocd_image_updater.json
}

resource "aws_iam_role_policy_attachment" "argocd_image_updater" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.argocd_image_updater.name
}

resource "aws_eks_pod_identity_association" "argocd_image_updater" {
  cluster_name    = var.cluster_name
  namespace       = "argocd"
  service_account = "argocd-image-updater"
  role_arn        = aws_iam_role.argocd_image_updater.arn
}

# Image Updater needs to list tags (DescribeImages, ListImages) – not in AmazonEC2ContainerRegistryReadOnly
# resource "aws_iam_role_policy" "argocd_image_updater_ecr_list" {
#   count = var.ecr_repository_arn != null ? 1 : 0

#   name   = "${var.cluster_name}-argocd-image-updater-ecr-list"
#   role   = aws_iam_role.argocd_image_updater.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect   = "Allow"
#         Action   = ["ecr:DescribeImages", "ecr:ListImages"]
#         Resource = var.ecr_repository_arn
#       }
#     ]
#   })
# }

# # Root Application (app-of-apps) – tworzone przez Terraform, nie ręcznie
# resource "kubernetes_manifest" "app_of_apps" {
#   manifest = {
#     apiVersion = "argoproj.io/v1alpha1"
#     kind       = "Application"
#     metadata = {
#       name      = "root-apps-of-apps"
#       namespace = "argocd"
#       finalizers = ["resources-finalizer.argocd.argoproj.io"]
#     }
#     spec = {
#       project = "default"
#       source = {
#         repoURL        = var.app_of_apps_repo_url
#         path           = var.app_of_apps_path
#         targetRevision = var.app_of_apps_target_revision
#         directory = {
#           recurse = true
#         }
#       }
#       destination = {
#         server    = "https://kubernetes.default.svc"
#         namespace = "argocd"
#       }
#       syncPolicy = {
#         automated = {
#           prune    = true
#           selfHeal  = true
#         }
#       }
#     }
#   }

#   depends_on = [helm_release.argocd]
# }

resource "tls_private_key" "git_deploy_key" {
  algorithm = "ED25519"
}

# 2. Tworzymy sekret w AWS Secrets Manager
resource "aws_secretsmanager_secret" "argocd_repo_secret" {
  name                    = "argocd/repo-credentials"
  recovery_window_in_days = 0
}

# 3. Zapisujemy klucz prywatny i URL do AWS
resource "aws_secretsmanager_secret_version" "argocd_repo_secret_ver" {
  secret_id     = aws_secretsmanager_secret.argocd_repo_secret.id
  secret_string = jsonencode({
    url           = var.app_of_apps_repo_url # np. git@github.com:k-napiontek/my-app.git
    sshPrivateKey = tls_private_key.git_deploy_key.private_key_openssh
  })
}

