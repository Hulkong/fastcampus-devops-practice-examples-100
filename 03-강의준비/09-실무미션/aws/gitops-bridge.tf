################################################################################
# EKS Blueprints Addons
################################################################################
module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  # Using GitOps Bridge (Skip Helm Install in Terraform)
  create_kubernetes_resources = false

  # EKS Blueprints Addons
  enable_cert_manager                 = var.addons.enable_cert_manager
  enable_aws_efs_csi_driver           = var.addons.enable_aws_efs_csi_driver
  enable_aws_fsx_csi_driver           = var.addons.enable_aws_fsx_csi_driver
  enable_aws_cloudwatch_metrics       = var.addons.enable_aws_cloudwatch_metrics
  enable_aws_privateca_issuer         = var.addons.enable_aws_privateca_issuer
  enable_cluster_autoscaler           = var.addons.enable_cluster_autoscaler
  enable_external_dns                 = var.addons.enable_external_dns
  enable_external_secrets             = var.addons.enable_external_secrets
  enable_aws_load_balancer_controller = var.addons.enable_aws_load_balancer_controller
  enable_fargate_fluentbit            = var.addons.enable_fargate_fluentbit
  enable_aws_for_fluentbit            = var.addons.enable_aws_for_fluentbit
  enable_aws_node_termination_handler = var.addons.enable_aws_node_termination_handler
  enable_karpenter                    = var.addons.enable_karpenter
  enable_velero                       = var.addons.enable_velero
  enable_aws_gateway_api_controller   = var.addons.enable_aws_gateway_api_controller

  karpenter = {
    repository_username = data.aws_ecrpublic_authorization_token.token.user_name
    repository_password = data.aws_ecrpublic_authorization_token.token.password
  }
  karpenter_enable_spot_termination          = true
  karpenter_enable_instance_profile_creation = true
  karpenter_node = {
    iam_role_use_name_prefix = false
  }

  external_dns_route53_zone_arns = [
    resource.aws_route53_zone.sub.arn
  ]

  tags = local.tags
}

locals {

  cluster_metadata = merge(
    module.eks_blueprints_addons.gitops_metadata,
    {
      aws_cluster_name = module.eks.cluster_name
      aws_region       = var.region
      aws_account_id   = data.aws_caller_identity.current.account_id
      aws_vpc_id       = module.vpc.vpc_id
    },
    {
      administrations_repo_url      = "${var.gitops_administrations_org}/${var.gitops_administrations_repo}"
      administrations_repo_basepath = var.gitops_administrations_basepath
      administrations_repo_path     = var.gitops_administrations_path
      administrations_repo_revision = var.gitops_administrations_revision,
      administrations_project       = local.argocd_project_administration
    },
    {
      addons_repo_url      = "${var.gitops_addons_org}/${var.gitops_addons_repo}"
      addons_repo_basepath = var.gitops_addons_basepath
      addons_repo_path     = var.gitops_addons_path
      addons_repo_revision = var.gitops_addons_revision,
      addons_project       = local.argocd_project_administration
    },
    {
      workload_repo_url      = "${var.gitops_workload_org}/${var.gitops_workload_repo}"
      workload_repo_basepath = var.gitops_workload_basepath
      workload_repo_path     = var.gitops_workload_path
      workload_repo_revision = var.gitops_workload_revision
      workload_project       = local.argocd_project_workload
    },
    {
      eks_cluster_domain = local.domain,
      environment        = local.env
    }
  )

  cluster_labels = merge(
    var.addons,
    { environment = local.env },
    { kubernetes_version = var.kubernetes_version },
    { aws_cluster_name = module.eks.cluster_name }
  )

}

################################################################################
# GitOps Bridge: Bootstrap for In-Cluster
################################################################################
module "gitops_bridge_bootstrap" {
  source = "github.com/gitops-bridge-dev/gitops-bridge-argocd-bootstrap-terraform?ref=v2.0.0"

  cluster = {
    metadata = local.cluster_metadata
    addons   = local.cluster_labels
  }
  #apps       = local.argocd_apps
  argocd = {
    create_namespace = false
    set              = []
    set_sensitive = [
      {
        name  = "configs.secret.argocdServerAdminPassword"
        value = bcrypt_hash.argocd_admin_password.id
      },
      {
        name  = "configs.secret.githubSecret"
        value = random_password.github_secret.result
      }
    ]
  }

  depends_on = [
    module.eks_blueprints_addons,
    kubernetes_namespace.argocd,
    kubernetes_secret.git_secrets,
    kubernetes_secret.git_repo_credential_templates
  ]
}

################################################################################
# GitOps Bridge: Bootstrap for Apps
################################################################################
module "argocd" {
  source = "./argocd-bootstrap"

  count = var.enable_gitops_auto_bootstrap ? 1 : 0

  administrations = {
    repo_url        = "${var.gitops_administrations_org}/${var.gitops_administrations_repo}"
    path            = "${var.gitops_administrations_basepath}${var.gitops_administrations_path}"
    target_revision = var.gitops_administrations_revision
    project         = local.argocd_project_administration
  }

  addons = {
    repo_url        = "${var.gitops_addons_org}/${var.gitops_addons_repo}"
    path            = "${var.gitops_addons_basepath}${var.gitops_addons_path}"
    target_revision = var.gitops_addons_revision
    project         = local.argocd_project_administration
  }

  workloads = {
    repo_url        = "${var.gitops_workload_org}/${var.gitops_workload_repo}"
    path            = "${var.gitops_workload_basepath}${var.gitops_workload_path}"
    target_revision = var.gitops_addons_revision
    project         = local.argocd_project_workload
  }

  env = local.env

  depends_on = [module.gitops_bridge_bootstrap]
}
