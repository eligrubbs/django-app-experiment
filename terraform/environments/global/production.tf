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

resource "tfe_variable" "django_secret_key" {
  key = "django_secret_key"
  category = "terraform"
  description = "Secret key for the django web app."
  sensitive = true
  variable_set_id = tfe_variable_set.production.id
}

resource "tfe_variable" "backend_neon_connection_str_prod" {
  key = "backend_neon_connection_str_prod"
  category = "terraform"
  description = "Connection String for Neon Production Database"
  sensitive = true
  variable_set_id = tfe_variable_set.production.id
}

resource "tfe_variable" "django_health_check_secret" {
  key = "django_health_check_secret"
  category = "terraform"
  description = "Secret which is added after /health/ to prevent abuse in production"
  sensitive = true
  variable_set_id = tfe_variable_set.production.id
}
