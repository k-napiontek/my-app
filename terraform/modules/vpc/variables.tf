variable "env" {}
variable "cluster_name" {}
variable "vpc_cidr" {}
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
variable "tags" {
  type    = map(string)
  default = {}
}