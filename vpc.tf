provider "aws" {
  region = var.region
}

#Pull all available AZs
data "aws_availability_zones" "available" {}

##The cluster name prefix can be changed here
locals {
  cluster_name = "Otus-Take-Home-eks-${random_string.suffix.result}"
}

#Random string generator for the end of cluster name
resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"
  
  #To change the name of the VPC modify name attr
  name                 = "otus-take-home-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = false
  single_nat_gateway   = false
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }
}
