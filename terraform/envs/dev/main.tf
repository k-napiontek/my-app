locals {
  cluster_name = "${var.env}-${var.cluster_name}"


  tags = merge(var.tags, {
    Environment = var.env
    Terraform   = "true"
    Project     = var.project
  })

}

module "vpc" {
  source = "../../modules/vpc"

  env                  = var.env
  cluster_name         = var.cluster_name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  single_nat_gateway   = var.single_nat_gateway
  tags                 = local.tags
}

module "eks" {
  source = "../../modules/eks"

  cluster_name       = local.cluster_name
  kubernetes_version = var.kubernetes_version
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnets

  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  cloudwatch_log_retention_days        = var.cloudwatch_log_retention_days

   eks_managed_node_groups = {
    general = {
      instance_types = var.node_instance_types
      min_size       = var.node_min_size
      max_size       = var.node_max_size
      desired_size   = var.node_desired_size
    }
  }

  # vpc-cni i coredns muszą być przed node group (before_compute), żeby węzły miały sieć przy starcie
  addons = {
    vpc-cni = {
      before_compute = true
      most_recent    = true
    }
    coredns = {
      most_recent    = true
    }
    kube-proxy = { most_recent = true }
  }

  tags = local.tags
}

module "argocd" {
  source = "../../modules/argocd"

  depends_on = [module.eks]
}

module "ecr" {
  source = "../../modules/ecr"

  repository_name = "${var.env}-${var.project}"
  github_repo     = var.github_repo

  tags = local.tags
}