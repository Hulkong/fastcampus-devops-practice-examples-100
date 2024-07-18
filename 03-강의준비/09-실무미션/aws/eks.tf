resource "aws_ec2_tag" "subnet_private_eks_common_tag" {
  count       = length(data.aws_subnets.private_eks) > 0 ? length(data.aws_subnets.private_eks) : 0
  resource_id = element(data.aws_subnets.private_eks.ids, count.index)
  key         = "kubernetes.io/cluster/${join("-", [local.prefix, "eks"])}"
  value       = "shared"
}

resource "aws_ec2_tag" "subnet_private_eks_karpenter_tag" {
  count       = length(data.aws_subnets.private_eks) > 0 ? length(data.aws_subnets.private_eks) : 0
  resource_id = element(data.aws_subnets.private_eks.ids, count.index)
  key         = "karpenter.sh/discovery"
  value       = join("-", [local.prefix, "eks"])
}

resource "aws_ec2_tag" "subnet_public_eks_elb_tag" {
  count       = length(data.aws_subnets.public_net) > 0 ? length(data.aws_subnets.public_net) : 0
  resource_id = element(data.aws_subnets.public_net.ids, count.index)
  key         = "kubernetes.io/role/elb"
  value       = 1
}

resource "aws_ec2_tag" "subnet_private_eks_elb_tag" {
  count       = length(data.aws_subnets.private_net) > 0 ? length(data.aws_subnets.private_net) : 0
  resource_id = element(data.aws_subnets.private_net.ids, count.index)
  key         = "kubernetes.io/role/internal-elb"
  value       = 1
}


# ################################################################################
# # Cluster
# ################################################################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.15"

  cluster_name                   = local.name
  cluster_version                = "1.28"
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  create_cluster_security_group = false
  create_node_security_group    = false

  eks_managed_node_groups = {
    bottlerocket = {
      name                     = join("-", [local.name, "eks", "nodegroup", "mgmt"])
      use_name_prefix          = false
      iam_role_name            = join("-", [local.name, "eks", "nodegroup", "mgmt"])
      iam_role_use_name_prefix = false

      ami_type = "BOTTLEROCKET_x86_64"
      platform = "bottlerocket"

      instance_types = [
        "t3.small"
      ]

      capacity_type = "ON_DEMAND"

      min_size     = 1
      max_size     = 10
      desired_size = 5
    }
  }

  # EKS Addons
  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {}
  }

  iam_role_name            = join("-", [local.name, "eks", "nodegroup"])
  iam_role_use_name_prefix = true

  manage_aws_auth_configmap = true
  aws_auth_roles = [
    # We need to add in the Karpenter node IAM role for nodes launched by Karpenter
    {
      rolearn  = module.eks_blueprints_addons.karpenter.node_iam_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes",
      ]
    },
  ]

  create_kms_key              = false
  cluster_encryption_config   = {}
  create_cloudwatch_log_group = false

  tags = merge(local.tags, {
    # NOTE - if creating multiple security groups with this module, only tag the
    # security group that Karpenter should utilize with the following tag
    # (i.e. - at most, only one security group should have this tag in your account)
    "karpenter.sh/discovery" = local.name
  })
}

data "aws_iam_policy_document" "ebs_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateVolume",
      "ec2:CreateTags",
      "ec2:AttachVolume",
      "ec2:DetachVolume"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ebs_policy" {
  name        = join("-", [local.prefix, "ebs-permission"])
  description = "policy for ebs volume attachment"
  policy      = data.aws_iam_policy_document.ebs_policy.json
}

resource "aws_iam_role_policy_attachment" "ebs_role" {
  role       = module.eks_blueprints_addons.karpenter.node_iam_role_name
  policy_arn = aws_iam_policy.ebs_policy.arn
}
