provider "tfe" {
}

resource "tfe_variable_set" "global" {
  name         = "Global Settings"
  description  = "For variables that are used in multiple or all environments"
  organization = var.tfc_organization_name
  global       = true
}

##################
# Environment Variables for all remote workspaces to use when
# performing plan applies and runs.
##################

resource "tfe_variable" "render_api_key" {
  key             = "RENDER_API_KEY"
  category        = "env"
  description     = "Render API Key. Must be manually set / refreshed."
  sensitive       = true
  variable_set_id = tfe_variable_set.global.id
}

resource "tfe_variable" "render_owner_id" {
  key             = "RENDER_OWNER_ID"
  value           = "tea-d7mjfisvikkc7380an30"
  category        = "env"
  description     = "Render Owner ID."
  variable_set_id = tfe_variable_set.global.id
}

resource "tfe_variable" "cloudflare_api_token" {
  key             = "CLOUDFLARE_API_TOKEN"
  category        = "env"
  description     = "Cloudflare API token for handling domain configuration. Must be manually set / refreshed."
  sensitive       = true
  variable_set_id = tfe_variable_set.global.id
}

##################
# Terraform Variables for all remote workspaces to use when
# performing plan applies and runs.
# Note: HCP Terraform will throw a warning for unused variables
##################

resource "tfe_variable" "ghcr_auth_token" {
  key             = "ghcr_auth_token"
  category        = "terraform"
  description     = "GitHub Container Registry auth token"
  sensitive       = true
  variable_set_id = tfe_variable_set.global.id
}

resource "tfe_variable" "ghcr_username" {
  key             = "ghcr_username"
  category        = "terraform"
  description     = "GitHub username for GHCR authentication"
  sensitive       = true
  variable_set_id = tfe_variable_set.global.id
}

####
# Redundantly repeated so terraform shuts the hell up
####

variable "ghcr_auth_token" {
  description = "GitHub Container Registry auth token (Personal Access Token with read:packages scope)"
  type        = string
  sensitive   = true
}

variable "ghcr_username" {
  description = "GitHub username for GHCR authentication"
  type        = string
  sensitive   = true
}
