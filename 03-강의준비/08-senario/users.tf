locals {

  # A map of admin machine users. These users are used for tasks such like CI & CD, releasing, etc.
  admin_machine_users = {
    "devops-sg+github@kasacorp.com" = "kasa-singapore"
  }

  # A map of GitHub users that should have admin permissions
  admin_users = {
    "nissi@kasacorp.com" = "wonyee2"
  }

  devops_users = {
    "cdfgogo0615@naver.com" = "Hulkong"
    "sena0711@gmail.com"    = "sena0711"
  }

  data_users = {
    "patrick.chang1223@gmail.com" = "pjloveshiphop"
  }

  secops_users = {
    "sgops81@gmail.com" = "kez-park"
  }

  backend_users = {
    "kirby@kasacorp.com"     = "gunsookirby"
    "kyle@kasacorp.com"      = "kyle-kasa"
    "hannah@kasacorp.com"    = "yangahhh"
    "leelee@kasacorp.com"    = "kasa-leelee"
    "leelightreal@gmail.com" = "lightreal"
    "koko@kasacorp.com"      = "kokohanii"
  }

  backend_managers = {
    "kirby@kasacorp.com"     = "gunsookirby"
    "kyle@kasacorp.com"      = "kyle-kasa"
    "leelightreal@gmail.com" = "lightreal"
  }

  frontend_users = {
    "santa@kasacorp.com"  = "santa-hwang"
    "naeun0739@gmail.com" = "naeun419"
    "kirby@kasacorp.com"  = "gunsookirby"
    "kyle@kasacorp.com"   = "kyle-kasa"
  }

  blockchain_users = {
    "leelightreal@gmail.com" = "lightreal"
  }

  partner_users = {
    "goofcode@gmail.com" = "goofcode"
  }

  # A map of member machine users. These users are used by automation processes such as cloning repositories
  member_machine_users = {}

  # A map of GitHub users that should have member permissions
  member_users = {}

  # We merge the maps of members and admins and pass them as arguments to the module
  admins = merge(
    local.admin_machine_users,
    local.admin_users,
    local.devops_users
  )

  members = merge(
    local.member_machine_users,
    local.backend_users,
    local.backend_users,
    local.frontend_users,
    local.blockchain_users
  )
}
