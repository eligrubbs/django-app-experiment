terraform {
  cloud {
    organization = "hairbrush-org-12345"
    workspaces {
      name = "hairbrush-project-bootstrap"
    }
  }

  required_providers {

    tfe = {
      source  = "hashicorp/tfe"
      version = "0.74.1"
    }

  }

  required_version = ">= 1.14"
}
