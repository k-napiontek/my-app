variable "cluster_name" {}
variable "kubernetes_version" {}
variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}

variable "cluster_endpoint_public_access" {
  type    = bool
  default = false
}

variable "cluster_endpoint_public_access_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "cloudwatch_log_retention_days" {
  type    = number
  default = 90
}

variable "eks_managed_node_groups" {
  type    = any
  default = {}
}

variable "addons" {
  type    = any
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}