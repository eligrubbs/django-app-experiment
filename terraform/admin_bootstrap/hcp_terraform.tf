provider "tfe" {
  token = var.cli_set_tfe_token
  organization = var.tfc_organization_name
  hostname = var.tfc_hostname
}

#####
# Create simple global workspace with the TFE_TOKEN set
#####

# Variable Set for holding all important variables declared further down in this file
resource "tfe_variable_set" "admin" {
  name = "global admin bootstrapped set"
  organization = var.tfc_organization_name
  global = true
  description = "Created by the admin."
}

# Set at global level so all workspaces don't have to worry about it!
resource "tfe_variable" "tfc_team_token" {
  variable_set_id = tfe_variable_set.admin.id
  key = "TFE_TOKEN"
  value = var.cli_set_tfe_token
  category = "env"
  sensitive = true
  description = "The token for all workspaces to use tfe provider to edit variables, etc."
}
