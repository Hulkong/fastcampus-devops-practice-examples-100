################################################################################
# GitOps Bridge: Private ssh keys for git
################################################################################
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
  depends_on = [module.eks_blueprints_addons]
}

resource "kubernetes_secret" "git_secrets" {
  for_each = var.enable_git_ssh ? {
    git-addons = {
      type          = "git"
      url           = var.gitops_addons_org
      sshPrivateKey = file(pathexpand(local.git_private_ssh_key))
    }
    git-workloads = {
      type          = "git"
      url           = var.gitops_workload_org
      sshPrivateKey = file(pathexpand(local.git_private_ssh_key))
    }
  } : {}
  metadata {
    name      = each.key
    namespace = kubernetes_namespace.argocd.metadata[0].name
    labels = {
      "argocd.argoproj.io/secret-type" = "repo-creds"
    }
  }
  data       = each.value
  depends_on = [kubernetes_namespace.argocd]
}


################################################################################
# GitOps Bridge: Repository connection using Credential templates
################################################################################
resource "kubernetes_secret" "git_repo_credential_templates" {
  metadata {
    name      = "repo-credential-templates"
    namespace = kubernetes_namespace.argocd.metadata[0].name
    labels = {
      "argocd.argoproj.io/secret-type" = "repo-creds"
    }
  }

  data = {
    username = var.gitops_org_username
    password = var.gitops_org_password
    url      = var.gitops_addons_org
  }

  type       = "Opaque"
  depends_on = [kubernetes_namespace.argocd]
}


################################################################################
# GitOps Bridge: Credential of ArgoCD Vault Plugin
################################################################################
resource "kubernetes_secret" "argocd_vault_plugin_credentials" {
  metadata {
    name      = "argocd-vault-plugin-credentials"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }

  data = {
    AVP_TYPE : "awssecretsmanager"
    AWS_REGION : var.region
  }

  type       = "Opaque"
  depends_on = [kubernetes_namespace.argocd]
}
