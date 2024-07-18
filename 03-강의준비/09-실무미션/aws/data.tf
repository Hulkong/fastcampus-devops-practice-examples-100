data "aws_availability_zones" "available" {}

data "aws_region" "current" {}

# Find the user currently in use by AWS
data "aws_caller_identity" "current" {}

data "aws_eks_cluster_auth" "kubernetes" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "argocd" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "helm" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "kubectl" {
  name = module.eks.cluster_name
}

data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

data "aws_subnets" "public_net" {

  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = ["*public-net*"]
  }

  depends_on = [module.vpc.public_subnets]
}

data "aws_subnets" "private_net" {

  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = ["*private-net*"]
  }

  depends_on = [module.vpc.private_subnets]
}

data "aws_subnets" "private_eks" {

  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = ["*private-eks*"]
  }

  depends_on = [module.vpc.private_subnets]
}

data "aws_subnets" "private_eks_abc_zones" {

  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = ["*private-eks*"]
  }
  filter {
    name   = "availability-zone"
    values = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b", "${data.aws_region.current.name}c"]
  }

  depends_on = [module.vpc.private_subnets]
}

data "aws_subnets" "private_data" {

  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = ["*private-data*"]
  }

  depends_on = [module.vpc.private_subnets]
}

data "aws_route53_zone" "selected" {
  name = "${local.prod_domain}."
}
