################################################################################
# ArgoCD Project: administration
################################################################################
resource "argocd_project" "administration" {
  metadata {
    name        = var.administrations.project
    namespace   = "argocd"
    labels      = {}
    annotations = {}
  }

  spec {
    description = "Project to manage add-on, k8s admin resources, argocd project"

    source_namespaces = ["*"]
    source_repos      = ["*"]

    destination {
      server    = "*"
      namespace = "*"
      name      = "*"
    }

    cluster_resource_blacklist {}
    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    orphaned_resources {
      warn = true
    }

    signature_keys = []
  }
}


################################################################################
# ArgoCD Project: workload
################################################################################
resource "argocd_project" "workload" {
  metadata {
    name        = var.workloads.project
    namespace   = "argocd"
    labels      = {}
    annotations = {}
  }

  spec {
    description = "Project to manage services"

    source_namespaces = ["*"]
    source_repos      = ["*"]

    destination {
      server    = "*"
      namespace = "*"
      name      = "*"
    }

    cluster_resource_blacklist {}
    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    orphaned_resources {
      warn = true
    }

    signature_keys = []
  }
}


################################################################################
# ArgoCD Application: administrations
################################################################################
# resource "argocd_application" "bootstrap_administrations" {

#   metadata {
#     name      = "bootstrap-administrations"
#     namespace = "argocd"
#     labels = {
#       cluster = "in-cluster"
#     }
#     annotations = {}
#   }
#   cascade = true
#   wait    = true
#   spec {
#     project = argocd_project.administration.metadata[0].name
#     destination {
#       name      = "in-cluster"
#       namespace = "argocd"
#     }
#     source {
#       repo_url        = var.administrations.repo_url
#       path            = var.administrations.path
#       target_revision = var.administrations.target_revision
#       directory {
#         recurse = true
#         exclude = "exclude/*"
#       }
#     }
#     sync_policy {
#       automated {
#         prune     = true
#         self_heal = true
#       }
#     }
#   }
# }


################################################################################
# ArgoCD Application: addons
################################################################################
resource "argocd_application" "bootstrap_addons" {

  metadata {
    name      = "bootstrap-addons"
    namespace = "argocd"
    labels = {
      cluster = "in-cluster"
    }
    annotations = {}
  }
  cascade = true
  wait    = true
  spec {
    project = argocd_project.administration.metadata[0].name
    destination {
      name      = "in-cluster"
      namespace = "argocd"
    }
    source {
      repo_url        = var.addons.repo_url
      path            = var.addons.path
      target_revision = var.addons.target_revision
      directory {
        recurse = true
        exclude = "exclude/*"
      }
    }
    sync_policy {
      automated {
        prune     = true
        self_heal = true
      }
    }
  }
}


################################################################################
# ArgoCD Application: workloads
################################################################################
resource "argocd_application" "bootstrap_workloads" {

  metadata {
    name      = "bootstrap-workloads"
    namespace = "argocd"
    labels = {
      cluster = "in-cluster"
    }
    annotations = {}
  }
  cascade = true
  wait    = true
  spec {
    project = argocd_project.workload.metadata[0].name
    destination {
      name      = "in-cluster"
      namespace = "argocd"
    }
    source {
      repo_url        = var.workloads.repo_url
      path            = var.workloads.path
      target_revision = var.workloads.target_revision
      directory {
        recurse = true
        exclude = "exclude/*"
      }
    }
    sync_policy {
      automated {
        prune     = true
        self_heal = true
      }
    }
  }
  depends_on = [argocd_application.bootstrap_addons]
}


