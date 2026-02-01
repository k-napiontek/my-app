module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  # ==================== PODSTAWY ====================
  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # ==================== API ENDPOINT ====================
  endpoint_public_access = true


  # ==================== IAM & IRSA ====================
  enable_irsa = true

  enable_cluster_creator_admin_permissions = true

  # ==================== SZYFROWANIE ====================
  create_kms_key          = true
  attach_encryption_policy = true
  enable_kms_key_rotation = true

  encryption_config = {
    resources = ["secrets"]
  }

  # ==================== LOGOWANIE ====================
  create_cloudwatch_log_group  = true
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_retention_days

  enabled_log_types = ["api", "audit", "authenticator"]

  # ==================== AUTHENTICATION ====================
  authentication_mode = "API_AND_CONFIG_MAP"

  # ==================== COMPUTE (node pools) ====================
    eks_managed_node_groups = var.eks_managed_node_groups

  # ==================== ADDONY ====================
  addons = var.addons

  tags = var.tags
}