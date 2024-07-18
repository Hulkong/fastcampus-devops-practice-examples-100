################################################################################
# ArgoCD Admin Password credentials with Secrets Manager
# Login to AWS Secrets manager with the same role as Terraform to extract the ArgoCD admin password with the secret name as "argocd"
################################################################################
resource "random_password" "argocd_admin_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Argo requires the password to be bcrypt, we use custom provider of bcrypt,
# as the default bcrypt function generates diff for each terraform plan
resource "bcrypt_hash" "argocd_admin_password" {
  cleartext = random_password.argocd_admin_password.result
}


resource "random_password" "github_secret" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "argocd" {
  name                    = join("/", [local.name, local.env, "argocd"])
  recovery_window_in_days = 0 # Set to zero for this example to force delete during Terraform destroy
}

resource "aws_secretsmanager_secret_version" "argocd" {
  secret_id = aws_secretsmanager_secret.argocd.id
  secret_string = jsonencode({
    "ADMIN_PASSWORD" = random_password.argocd_admin_password.result,
    "GITHUB_SECRET"  = random_password.github_secret.result
  })
}
