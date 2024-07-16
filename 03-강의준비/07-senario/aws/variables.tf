# variable "argocd_admin_password" {
#   type        = string
#   description = "The password to use for the `admin` Argo CD user."
# }

variable "enable_git_ssh" {
  description = "Use git ssh to access all git repos using format git@github.com:<org>"
  type        = bool
  default     = false
}
variable "ssh_key_path" {
  description = "SSH key path for git access"
  type        = string
  default     = "~/.ssh/id_rsa"
}
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "172.0.0.0/16"
}
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}
variable "addons" {
  description = "Kubernetes addons"
  type        = any
  default = {
    # aws
    enable_cert_manager                 = true
    enable_aws_ebs_csi_resources        = false
    enable_aws_cloudwatch_metrics       = false
    enable_external_secrets             = false
    enable_aws_load_balancer_controller = true
    enable_aws_for_fluentbit            = false
    enable_karpenter                    = true
    enable_aws_ingress_nginx            = false
    enable_metrics_server               = true
    enable_kyverno                      = false

    # Enable if want argo manage argo from gitops
    enable_argocd = true

    enable_aws_efs_csi_driver                    = false
    enable_aws_fsx_csi_driver                    = false
    enable_aws_privateca_issuer                  = false
    enable_cluster_autoscaler                    = true
    enable_external_dns                          = true
    enable_fargate_fluentbit                     = false
    enable_aws_node_termination_handler          = false
    enable_velero                                = false
    enable_aws_gateway_api_controller            = false
    enable_aws_secrets_store_csi_driver_provider = false
    enable_ack_apigatewayv2                      = false
    enable_ack_dynamodb                          = false
    enable_ack_s3                                = false
    enable_ack_rds                               = false
    enable_ack_prometheusservice                 = false
    enable_ack_emrcontainers                     = false
    enable_ack_sfn                               = false
    enable_ack_eventbridge                       = false

    enable_argo_rollouts                   = false
    enable_argo_events                     = false
    enable_argo_workflows                  = false
    enable_cluster_proportional_autoscaler = false
    enable_gatekeeper                      = false
    enable_gpu_operator                    = false
    enable_ingress_nginx                   = false
    enable_kube_prometheus_stack           = false
    enable_prometheus_adapter              = false
    enable_secrets_store_csi_driver        = false
    enable_vpa                             = false
  }
}

# Administrations Git
variable "gitops_administrations_org" {
  description = "Git repository org/user contains for administrations"
  type        = string
  default     = "https://github.com/Hulkong"
}

variable "gitops_administrations_repo" {
  description = "Git repository contains for administrations"
  type        = string
  default     = "fastcampus-devops-practice-examples-100-gitops"
}

variable "gitops_administrations_revision" {
  description = "Git repository revision/branch/ref for administrations"
  type        = string
  default     = "main"
}

variable "gitops_administrations_basepath" {
  description = "Git repository base path for administrations"
  type        = string
  default     = ""
}

variable "gitops_administrations_path" {
  description = "Git repository path for administrations"
  type        = string
  default     = "bootstrap/control-plane/administrations"
}

# Addons Git
variable "gitops_addons_org" {
  description = "Git repository org/user contains for addons"
  type        = string
  default     = "https://github.com/Hulkong"
}

variable "gitops_addons_repo" {
  description = "Git repository contains for addons"
  type        = string
  default     = "fastcampus-devops-practice-examples-100-gitops"
}

variable "gitops_addons_revision" {
  description = "Git repository revision/branch/ref for addons"
  type        = string
  default     = "main"
}

variable "gitops_addons_basepath" {
  description = "Git repository base path for addons"
  type        = string
  default     = ""
}

variable "gitops_addons_path" {
  description = "Git repository path for addons"
  type        = string
  default     = "bootstrap/control-plane/addons"
}

# Workloads Git
variable "gitops_workload_org" {
  description = "Git repository org/user contains for workload"
  type        = string
  default     = "https://github.com/Hulkong"
}

variable "gitops_workload_repo" {
  description = "Git repository contains for workload"
  type        = string
  default     = "fastcampus-devops-practice-examples-100-gitops"
}

variable "gitops_workload_revision" {
  description = "Git repository revision/branch/ref for workload"
  type        = string
  default     = "main"
}

variable "gitops_workload_basepath" {
  description = "Git repository base path for workload"
  type        = string
  default     = ""
}

variable "gitops_workload_path" {
  description = "Git repository path for workload"
  type        = string
  default     = "bootstrap/workloads"
}

variable "enable_gitops_auto_bootstrap" {
  description = "Automatically deploy addons"
  type        = bool
  default     = true
}

variable "gitops_org_username" {
  description = "Git org system account"
  type        = string
  sensitive   = true
}

variable "gitops_org_password" {
  description = "PAT of Git org system account"
  type        = string
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  default = ""
}

variable "AWS_ACCESS_KEY_ID" {
  default = ""
}
