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
