################################################################################
# S3
################################################################################
# resource "aws_s3_bucket" "test" {
#   bucket        = format("%s-%s", local.name, "s3")
#   force_destroy = true
# }

# resource "aws_s3_bucket_public_access_block" "test" {
#   bucket = aws_s3_bucket.test.id

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

# data "aws_iam_policy_document" "policy" {
#   statement {
#     effect    = "Allow"
#     actions   = ["s3:PutObject"]
#     resources = ["${aws_s3_bucket.test.arn}/*"]
#   }
# }

# resource "aws_iam_policy" "policy" {
#   name        = "test-s3-putobejct"
#   description = "A test putObejct policy"
#   policy      = data.aws_iam_policy_document.policy.json
# }

# resource "aws_iam_role_policy_attachment" "test" {
#   role       = module.eks_blueprints_addons.karpenter.node_iam_role_name
#   policy_arn = aws_iam_policy.policy.arn
# }
