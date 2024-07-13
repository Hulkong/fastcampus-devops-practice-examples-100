module "team" {
  source  = "mineiros-io/team/github"
  version = "~> 0.6.0"

  name        = "Engineering"
  description = ""
  privacy     = "closed"
}


module "team_admin" {
  source  = "mineiros-io/team/github"
  version = "~> 0.6.0"

  name    = "Admins"
  privacy = "secret"

  members = concat(values(local.admin_machine_users), values(local.admin_users))

  admin_repositories = concat(
    local.share_repository,
    local.devops_repository,
    local.backend_repository,
    local.blockchain_repository
  )

  pull_repositories = []
  push_repositories = []
}


module "team_devops" {
  source  = "mineiros-io/team/github"
  version = "~> 0.6.0"

  name    = "DevOps"
  privacy = "secret"

  members = values(local.devops_users)

  admin_repositories = concat(
    local.share_repository,
    local.devops_repository,
    local.backend_repository,
    local.blockchain_repository
  )

  pull_repositories = []
  push_repositories = []
}

module "team_data" {
  source  = "mineiros-io/team/github"
  version = "~> 0.6.0"

  name    = "Data"
  privacy = "secret"

  members = values(local.data_users)

  push_repositories = concat(
    local.share_repository,
    local.devops_repository,
    local.backend_repository,
    local.blockchain_repository
  )
}

module "team_secops" {
  source  = "mineiros-io/team/github"
  version = "~> 0.6.0"

  name    = "SecOps"
  privacy = "secret"

  members = values(local.secops_users)

  push_repositories = concat(
    local.share_repository,
    local.devops_repository,
    local.backend_repository,
    local.blockchain_repository
  )
}

module "team_backend" {
  source  = "mineiros-io/team/github"
  version = "~> 0.6.0"

  name    = "Backend"
  privacy = "closed"

  members = values(local.backend_users)

  push_repositories = concat(
    local.share_repository,
    local.backend_repository
  )
}

module "team_backend_child_01" {
  source  = "mineiros-io/team/github"
  version = "~> 0.6.0"

  name           = "Backend Manager"
  privacy        = "closed"
  parent_team_id = module.team_backend.id

  members = values(local.backend_managers)

  maintain_repositories = concat(
    local.share_repository,
    local.backend_repository
  )
}

module "team_frontend" {
  source  = "mineiros-io/team/github"
  version = "~> 0.6.0"

  name    = "Frontend"
  privacy = "secret"

  members = values(local.frontend_users)

  maintain_repositories = concat(
    local.share_repository,
    local.frontend_repository,
    local.partner_repository,
    local.backend_repository
  )
}


module "team_blockchain" {
  source  = "mineiros-io/team/github"
  version = "~> 0.6.0"

  name    = "Blockchain"
  privacy = "secret"

  members = values(local.blockchain_users)

  maintain_repositories = concat(
    local.share_repository,
    local.backend_repository,
    local.blockchain_repository
  )
}

module "team_partner" {
  source  = "mineiros-io/team/github"
  version = "~> 0.6.0"

  name    = "Partner"
  privacy = "secret"

  members = values(local.partner_users)

  push_repositories = concat(
    local.partner_repository
  )
}

/*
module "team_reviewers" {
  source  = "mineiros-io/team/github"
  version = "0.1.2"

  name        = "Reviewers"
  description = "A team of users that are mandatory for reviewing Pull Requests."
  privacy     = "secret"

  members = [
    local.member_users["cdfgogo0615@naver.com"]
  ]

  maintainers = values(local.admin_users)
}

module "team_contributors" {
  source  = "mineiros-io/team/github"
  version = "0.1.2"

  name        = "Contributors"
  description = "A team of users that have the permission to contribute to repositories that are assigned to the team."
  privacy     = "secret"

  members = [
    local.member_users["cdfgogo0615@naver.com"]
  ]

  maintainers = values(local.admin_users)
}
*/
