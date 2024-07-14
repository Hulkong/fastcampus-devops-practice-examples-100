output "team" {
  description = "All outputs of the team module."
  value = [
    module.team,
    module.team_devops,
    module.team_backend,
    module.team_backend_child_01,
    module.team_frontend,
    module.team_partner
  ]
}
