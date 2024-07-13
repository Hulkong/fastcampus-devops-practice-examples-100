module "repository-part03-08-senario" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.10.0"

  name                   = "fastcampus-devops-practice-examples-100"
  allow_rebase_merge     = true
  allow_squash_merge     = true
  delete_branch_on_merge = true
  has_downloads          = true
  has_issues             = true
  has_projects           = true
  has_wiki               = true
}

# module "repository-part03-08-senario-example" {
#   source  = "mineiros-io/repository/github"
#   version = "~> 0.10.0"

#   name                   = "fastcampus-devops-practice-examples-100"
#   allow_rebase_merge     = true
#   allow_squash_merge     = true
#   delete_branch_on_merge = true
#   has_issues             = true
#   has_projects           = true
#   has_wiki               = true
#   branch_protections_v3 = [
#     {
#       branch                 = "main"
#       enforce_admins         = false
#       require_signed_commits = false
#       required_status_checks = {}

#       required_pull_request_reviews = {
#         dismiss_stale_reviews           = false
#         restrict_dismissals             = true
#         dismissal_teams                 = [module.team_backend_child_01.name]
#         require_code_owner_reviews      = false
#         required_approving_review_count = 1
#       }

#       restrictions = {
#         teams = [module.team_backend.name]
#       }
#     },
#     {
#       branch                 = "prod"
#       enforce_admins         = false
#       require_signed_commits = false

#       required_pull_request_reviews = {
#         dismiss_stale_reviews           = false
#         restrict_dismissals             = true
#         dismissal_teams                 = [module.team_backend_child_01.name]
#         require_code_owner_reviews      = false
#         required_approving_review_count = 1
#       }

#       restrictions = {
#         teams = [module.team_backend.name]
#       }
#     },
#     {
#       branch                 = "staging"
#       enforce_admins         = false
#       require_signed_commits = false

#       required_pull_request_reviews = {
#         dismiss_stale_reviews           = false
#         restrict_dismissals             = true
#         dismissal_teams                 = [module.team_backend_child_01.name]
#         require_code_owner_reviews      = false
#         required_approving_review_count = 1
#       }

#       restrictions = {
#         teams = [module.team_backend.name]
#       }
#     }
#   ]
# }
