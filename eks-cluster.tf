
module "eks" {
  source                    = "terraform-aws-modules/eks/aws"
  version                   = "17.24.0"
  cluster_name              = local.cluster_name
  #In production please do not upgrade by modifying this, take a nodegroup migration pattern
  cluster_version           = "1.20"
  subnets                   = module.vpc.public_subnets
  vpc_id                    = module.vpc.vpc_id
  #Comment out the below block to disable all logging, default retention is 90 days, a log group will be created automatically
  cluster_enabled_log_types = [
  "audit",
  "api",
  "authenticator"
]
  
  #This role is required to make sure nodes can join the cluster, if this is missing the nodes will go NotReady
  map_roles = [ { "groups": [ "system:bootstrappers","system:nodes" ], "rolearn": aws_iam_role.otus_demo.arn, "username": "system:node:{{EC2PrivateDNSName}}" } ]
  #This is for the user that terraform is running under so they may be cable to connect to the EKS dashboard.
  map_users = [
    {
      userarn   = var.admin_acct_arn
      username  = var.admin_acct_username
      groups    = ["system:masters"]
    } 
  ]
}


data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
#Nodegroup configiration
resource "aws_eks_node_group" "Otus_Demo_NG" {
  cluster_name              = local.cluster_name
  node_group_name           = "Otus_Demo_NG"
  node_role_arn             = aws_iam_role.otus_demo.arn
  subnet_ids                = module.vpc.public_subnets
  instance_types            = ["m5.xlarge"]
  
  #Modify to change the number of nodes in the cluster
  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }

  depends_on = [
    module.eks.aws_eks_cluster,
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

#This is the role for the EC2 Instances to run as
resource "aws_iam_role" "otus_demo" {
  name = "eks-cluster-otus-demo"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

#Role Dependnecy Block Start
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.otus_demo.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.otus_demo.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.otus_demo.name
}

resource "aws_iam_role_policy_attachment" "prod-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.otus_demo.name
}
#Role Dependnecy Block End