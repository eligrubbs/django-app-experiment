# Bootstrap Production variables

data "tfe_workspace" "production" {
  name         = "production"
  organization = var.tfc_organization_name
}

resource "tfe_variable_set" "production" {
  name              = "Production Settings"
  description       = "Variables specific to the production environment"
  organization      = var.tfc_organization_name
}

resource "tfe_workspace_variable_set" "production" {
    variable_set_id = tfe_variable_set.production.id
    workspace_id = data.tfe_workspace.production.id
}
#####
# Variables
#####

resource "tfe_variable" "backend_neon_connection_str_prod" {
    key = "backend_neon_connection_str_prod"
    category = "terraform"
    description = "Connection String for Neon Production Database"
    sensitive = true
    variable_set_id = tfe_variable_set.production.id
}
