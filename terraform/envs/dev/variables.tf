variable "env" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "project" {
  type    = string
  default = "myapp"
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

# VPC
variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}

# EKS
variable "kubernetes_version" {
  type = string
}

variable "cluster_endpoint_public_access" {
  type    = bool
  default = true
}

variable "cluster_endpoint_public_access_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "cloudwatch_log_retention_days" {
  type    = number
  default = 30
}

variable "node_instance_types" {
  type = list(string)
}

variable "node_desired_size" {
  type = number
}

variable "node_min_size" {
  type = number
}

variable "node_max_size" {
  type = number
}

variable "tags" {
  type    = map(string)
  default = {}
}

# ECR + GitHub Actions
variable "github_repo" {
  type        = string
  description = "GitHub repository in format owner/repo (e.g. myorg/project-1.02.2026)"
}