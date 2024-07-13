provider "github" {
  token = var.github_token
  owner = var.github_owner
}

resource "github_repository" "sample_repo" {
  name        = "sample-repo"
  description = "Sample repository for PR workflow"
  private     = false

  visibility = "public"
  auto_init  = true
}

resource "github_branch_protection" "main" {
  repository = github_repository.sample_repo.name
  pattern    = "main"

  required_status_checks {
    strict   = true
    contexts = []
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
    required_approving_review_count = 1
  }

  restrictions {
    users = []
    teams = []
  }
}

resource "github_actions_secret" "aws_access_key_id" {
  repository      = github_repository.sample_repo.name
  secret_name     = "AWS_ACCESS_KEY_ID"
  plaintext_value = var.aws_access_key_id
}

resource "github_actions_secret" "aws_secret_access_key" {
  repository      = github_repository.sample_repo.name
  secret_name     = "AWS_SECRET_ACCESS_KEY"
  plaintext_value = var.aws_secret_access_key
}
