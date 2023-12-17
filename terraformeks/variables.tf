variable "aws_region" {
  type    = string
  default = "ap-south-1" 
}

variable "eks_cluster_name" {
  type    = string
  default = "RR-cluster"
}

variable "node_group_name" {
  type    = string
  default = "cluster_NG"
}