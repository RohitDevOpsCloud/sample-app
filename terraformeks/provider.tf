terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region 
}

terraform {
  backend "s3" {
    bucket         = "rr-eks-infra"
    key            = "eks-cluster/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "RR-tf-lock-dynamo"
  }
}
