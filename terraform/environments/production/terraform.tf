terraform {
  cloud {
    organization = "hairbrush-org-12345"
    workspaces {
      name = "production"
    }
  }

  required_providers {
    render = {
      source  = "render-oss/render"
      version = "1.8.0"
    }

    tfe = {
      source  = "hashicorp/tfe"
      version = "0.74.1"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }

  required_version = ">= 1.14"
}
