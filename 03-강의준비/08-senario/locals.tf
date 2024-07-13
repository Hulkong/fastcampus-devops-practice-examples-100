locals {

  share_repository = [
    module.repository-k8s-manifests-sg.repository.name
  ]

  devops_repository = [
    module.repository-infrastructure-sg.repository.name
  ]

  backend_repository = [
    module.repository-kasa-api-sg.repository.name,
    module.repository-kasa-api-docs-sg.repository.name
  ]

  frontend_repository = [
    module.repository-kasa-operation-center-web-sg.repository.name,
    module.repository-kasa-brand-sg.repository.name,
    module.repository-kasa-deal-sg.repository.name,
    module.repository-kasa-exchange-web-sg.repository.name
  ]

  blockchain_repository = [
    module.repository-fabric-network-sg.repository.name,
    module.repository-fabric-manager-sg.repository.name,
    module.repository-kasa-ledger-cc-sg.repository.name
  ]

  partner_repository = [
    module.repository-kasa-brand-sg.repository.name,
    module.repository-kasa-deal-sg.repository.name,
    module.repository-kasa-exchange-web-sg.repository.name
  ]
}