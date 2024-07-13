provider "github" {
  owner = "kasa-sg"
}

terraform {
  required_version = "~> 1.0"

  required_providers {
    github = {
      #      source  = "integrations/github"
      source  = "hashicorp/github"
      version = "~> 4.0"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "kasa-sg"

    workspaces {
      name = "github"
    }
  }
}
