# module "iam_eks_role" {
#   source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   role_name = "part01_test_role"

#   role_policy_arns = {
#     policy = aws_iam_policy.policy.arn
#   }

#   oidc_providers = {
#     one = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["default:sample-app"]
#     }
#   }
# }
