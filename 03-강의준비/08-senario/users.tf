locals {

  # A map of admin machine users. These users are used for tasks such like CI & CD, releasing, etc.
  admin_machine_users = {}

  # A map of GitHub users that should have admin permissions
  admin_users = {
    "cdfgogo0615@naver.com" = "Hulkong"
    # "baramboys0615@gmail.com" = "hulkong2"
  }

  devops_users = {
    # "baramboys0615@gmail.com" = "hulkong2"
  }

  data_users = {}

  secops_users = {}

  backend_users = {}

  backend_managers = {}

  frontend_users = {}

  blockchain_users = {}

  partner_users = {}

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
