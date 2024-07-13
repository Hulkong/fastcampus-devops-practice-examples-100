module "repository-kasa-api-sg" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.10.0"

  name                   = "kasa-api-sg"
  allow_rebase_merge     = true
  allow_squash_merge     = true
  delete_branch_on_merge = true
  has_issues = true
  has_projects = true
  has_wiki = true
  branch_protections_v3 = [
    {
      branch                 = "master"
      enforce_admins         = false
      require_signed_commits = false
      required_status_checks = {
        contexts = [
        "continuous-integration/drone/push"
        ]
        include_admins = false
        strict = false
      }

      required_pull_request_reviews = {
        dismiss_stale_reviews           = false
        restrict_dismissals             = true
        dismissal_teams                 = [module.team_backend_child_01.name]
        require_code_owner_reviews      = false
        required_approving_review_count = 1
      }

      restrictions = {
        teams = [module.team_backend.name]
      }
    },
    {
      branch                 = "prod"
      enforce_admins         = false
      require_signed_commits = false

      required_pull_request_reviews = {
        dismiss_stale_reviews           = false
        restrict_dismissals             = true
        dismissal_teams                 = [module.team_backend_child_01.name]
        require_code_owner_reviews      = false
        required_approving_review_count = 1
      }

      restrictions = {
        teams = [module.team_backend.name]
      }
    },
    {
      branch                 = "staging"
      enforce_admins         = false
      require_signed_commits = false

      required_pull_request_reviews = {
        dismiss_stale_reviews           = false
        restrict_dismissals             = true
        dismissal_teams                 = [module.team_backend_child_01.name]
        require_code_owner_reviews      = false
        required_approving_review_count = 1
      }

      restrictions = {
        teams = [module.team_backend.name]
      }
    }
  ]
}

module "repository-k8s-manifests-sg" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.10.0"

  name                   = "k8s-manifests-sg"
  allow_rebase_merge     = true
  allow_squash_merge     = true
  delete_branch_on_merge = true
  has_downloads          = true
  has_issues             = true
  has_projects           = true
  has_wiki               = true
}

module "repository-infrastructure-sg" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.10.0"

  name                   = "infrastructure-sg"
  allow_rebase_merge     = true
  allow_squash_merge     = true
  delete_branch_on_merge = true
  has_downloads          = true
  has_issues             = true
  has_projects           = true
  has_wiki               = true
}

module "repository-kasa-operation-center-web-sg" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.10.0"

  name                   = "kasa-operation-center-web-sg"
  allow_rebase_merge     = true
  allow_squash_merge     = true
  delete_branch_on_merge = true
  branch_protections = [
    {
      branch                 = "master"
      enforce_admins         = false
      require_signed_commits = false

      required_pull_request_reviews = {
        dismiss_stale_reviews           = false
        restrict_dismissals             = true
        dismissal_teams                 = [module.team_frontend.name]
        require_code_owner_reviews      = false
        required_approving_review_count = 1
      }

      restrictions = {
        teams = [module.team_frontend.name]
      }
    },
    {
      branch                 = "prod"
      enforce_admins         = false
      require_signed_commits = false

      required_pull_request_reviews = {
        dismiss_stale_reviews           = false
        restrict_dismissals             = true
        dismissal_teams                 = [module.team_frontend.name]
        require_code_owner_reviews      = false
        required_approving_review_count = 1
      }

      restrictions = {
        teams = [module.team_frontend.name]
      }
    },
    {
      branch                 = "staging"
      enforce_admins         = false
      require_signed_commits = false

      required_pull_request_reviews = {
        dismiss_stale_reviews           = false
        restrict_dismissals             = true
        dismissal_teams                 = [module.team_frontend.name]
        require_code_owner_reviews      = false
        required_approving_review_count = 1
      }

      restrictions = {
        teams = [module.team_frontend.name]
      }
    }
  ]
}

module "repository-kasa-exchange-web-sg" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.10.0"

  name                   = "kasa-exchange-web-sg"
  allow_rebase_merge     = true
  allow_squash_merge     = true
  delete_branch_on_merge = true
  branch_protections = [
    {
      branch                 = "main"
      enforce_admins         = false
      require_signed_commits = false

      required_pull_request_reviews = {
        dismiss_stale_reviews           = false
        restrict_dismissals             = true
        dismissal_teams                 = [module.team_frontend.name]
        require_code_owner_reviews      = false
        required_approving_review_count = 1
      }

      restrictions = {
        teams = [module.team_frontend.name]
      }
    },
    {
      branch                 = "prod"
      enforce_admins         = false
      require_signed_commits = false

      required_pull_request_reviews = {
        dismiss_stale_reviews           = false
        restrict_dismissals             = true
        dismissal_teams                 = [module.team_frontend.name]
        require_code_owner_reviews      = false
        required_approving_review_count = 1
      }

      restrictions = {
        teams = [module.team_frontend.name]
      }
    },
    {
      branch                 = "staging"
      enforce_admins         = false
      require_signed_commits = false

      required_pull_request_reviews = {
        dismiss_stale_reviews           = false
        restrict_dismissals             = true
        dismissal_teams                 = [module.team_frontend.name]
        require_code_owner_reviews      = false
        required_approving_review_count = 1
      }

      restrictions = {
        teams = [module.team_frontend.name]
      }
    }
  ]
}


module "repository-kasa-api-docs-sg" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.10.0"

  name                   = "kasa-api-docs-sg"
  allow_rebase_merge     = true
  allow_squash_merge     = true
  delete_branch_on_merge = true
}

module "repository-kasa-deal-sg" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.10.0"

  name                   = "kasa-deal-sg"
  allow_rebase_merge     = true
  allow_squash_merge     = true
  delete_branch_on_merge = true
}

module "repository-kasa-brand-sg" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.10.0"

  name                   = "kasa-brand-sg"
  allow_rebase_merge     = true
  allow_squash_merge     = true
  delete_branch_on_merge = true
  branch_protections = [
    {
      branch                 = "main"
      enforce_admins         = false
      require_signed_commits = false

      required_pull_request_reviews = {
        dismiss_stale_reviews           = false
        restrict_dismissals             = true
        dismissal_teams                 = [module.team_frontend.name]
        require_code_owner_reviews      = false
        required_approving_review_count = 1
      }

      restrictions = {
        teams = [module.team_frontend.name]
      }
    },
    {
      branch                 = "staging"
      enforce_admins         = false
      require_signed_commits = false

      required_pull_request_reviews = {
        dismiss_stale_reviews           = false
        restrict_dismissals             = true
        dismissal_teams                 = [module.team_frontend.name]
        require_code_owner_reviews      = false
        required_approving_review_count = 1
      }

      restrictions = {
        teams = [module.team_frontend.name]
      }
    }
  ]
}

module "repository-fabric-network-sg" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.10.0"

  name                   = "fabric-network-sg"
  allow_rebase_merge     = true
  allow_squash_merge     = true
  delete_branch_on_merge = true
}

module "repository-fabric-manager-sg" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.10.0"

  name                   = "fabric-manager-sg"
  allow_rebase_merge     = true
  allow_squash_merge     = true
  delete_branch_on_merge = true
}

module "repository-kasa-ledger-cc-sg" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.10.0"

  name                   = "kasa-ledger-cc-sg"
  allow_rebase_merge     = true
  allow_squash_merge     = true
  delete_branch_on_merge = true
}

module "repository-trading-engine-sg" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.10.0"

  name                   = "trading-engine-sg"
  allow_rebase_merge     = true
  allow_squash_merge     = true
  delete_branch_on_merge = true
  has_downloads          = true
  has_projects           = true
  has_wiki               = true
}

module "repository-matching-engine-sg" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.10.0"

  name                   = "matching-engine-sg"
  allow_rebase_merge     = true
  allow_squash_merge     = true
  delete_branch_on_merge = true
  has_downloads          = true
  has_projects           = true
  has_wiki               = true
}
# resource "github_repository" "kasa_operation_center_web_sg" {
# name = "kasa-operation-center-web-sg"

# terraform import module.repository-trading-engine-sg.github_repository.repository trading-engine-sg
# terraform import module.repository-matching-engine-sg.github_repository.repository matching-engine-sg
