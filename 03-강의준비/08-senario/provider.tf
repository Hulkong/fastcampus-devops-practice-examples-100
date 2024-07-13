provider "github" {
  owner = ""
}

terraform {
  required_version = "~> 1.0"

  required_providers {
    github = {
      source  = "hashicorp/github"
      version = "~> 4.0"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = ""

    workspaces {
      name = "github"
    }
  }
}
