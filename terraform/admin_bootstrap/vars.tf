
variable "cli_set_tfe_token" {
  description = "required since tfe no longer is supposed to read my config file to get the token."
  type = string
  sensitive = true
}

variable "tfc_hostname" {
  type        = string
  default     = "app.terraform.io"
  description = "The hostname of the TFC or TFE instance you'd like to use with AWS"
}

variable "tfc_organization_name" {
  type        = string
  default     = "hairbrush-org-12345"
  description = "The name of your Terraform Cloud organization"
}
