# Setup for module
variable "environment" {
  description = "Environment that the service runs in"
  type        = string

  validation {
    condition     = contains(["production", "test"], var.environment)
    error_message = "Must be either \"production\", or \"test\"."
  }
}

variable "render_environment_id" {
  description = "The environment ID in Render"
  type        = string
}

variable "registry_credential_id" {
  description = "Render registry credential ID."
  type        = string
  sensitive   = true
}

# Variables for configuring the services
variable "api_service_config" {
  description = "API service configuration"
  type = object({
    # allowed_hosts          = string
    # cors_origins           = string
    custom_domains         = list(object({ name = string }))
    image_url              = string
    image_digest           = string
    postgres_database      = string
    plan                   = optional(string, "starter")
    health_check_secret    = string
  })
}

variable "postgres_config" {
  description = "PostgreSQL connection configuration. Please either provide all of host, post, user, and password or just connection_str"
  type = object({
    host           = optional(string, "")
    port           = optional(string, "")
    user           = optional(string, "")
    password       = optional(string, "")
    connection_str = optional(string, "")
  })
  sensitive = true
}

variable "django_config" {
    description = "Django specific variables to set."
    type = object({
      secret_key = string # 'djfoasdjfklalfjdsaf' for example
      settings_module = string # 'hairbrush.settings' for example
    })
    sensitive = true
}
