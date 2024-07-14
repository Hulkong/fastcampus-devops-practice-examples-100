provider "github" {
  owner = "fastcampus-devops-practice-examples-100"
}

terraform {
  required_version = "~> 1.0"

  required_providers {
    github = {
      source  = "hashicorp/github"
      version = "~> 4.0"
    }
  }
}
