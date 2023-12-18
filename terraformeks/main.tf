data "aws_vpc" "default" {
  default = true
} 

data "aws_subnets" "subnet_ids" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


data "aws_subnet" "subnet" {
  for_each = toset(data.aws_subnets.subnet_ids.ids)
  id       = each.value
}

data "aws_iam_role" "cluster_role" {
  name = "eksctl-test-cluster-cluster-ServiceRole-qA6vXw8sFh1r"
}
data "aws_iam_role" "NG_role" {
  name = "eksctl-test-cluster-nodegroup-linu-NodeInstanceRole-tuolIdjBxbhh"
}

resource "aws_eks_cluster" "cluster" {
  name     = var.eks_cluster_name
  role_arn = data.aws_iam_role.cluster_role.arn

  vpc_config {
    subnet_ids = data.aws_subnets.subnet_ids.ids
  }
}

# output "endpoint" {
#   value = aws_eks_cluster.cluster.endpoint
# }

# output "kubeconfig-certificate-authority-data" {
#   value = aws_eks_cluster.cluster.certificate_authority[0].data
# }

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = data.aws_iam_role.NG_role.arn
  subnet_ids      = data.aws_subnets.subnet_ids.ids
  instance_types  = ["t3.medium"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

}