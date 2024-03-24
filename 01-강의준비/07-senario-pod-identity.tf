

# resource "aws_eks_pod_identity_association" "association" {
#   cluster_name    = module.eks.cluster_name
#   namespace       = "default"
#   service_account = "sample-app"
#   role_arn        = aws_iam_role.part01_pod_identity.arn
# }

# resource "aws_iam_role" "part01_pod_identity" {
#   name               = "part01-eks-pod-identity"
#   assume_role_policy = data.aws_iam_policy_document.pod_identity_assume_role.json
#   inline_policy {
#     name   = "s3PutObject"
#     policy = data.aws_iam_policy_document.policy.json
#   }
# }

# data "aws_iam_policy_document" "pod_identity_assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["pods.eks.amazonaws.com"]
#     }

#     actions = [
#       "sts:AssumeRole",
#       "sts:TagSession"
#     ]
#   }
# }
