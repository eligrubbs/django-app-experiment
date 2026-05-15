# =============================================================================
# Variables
# =============================================================================

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

variable "backend_neon_connection_str_prod" {
  description = "Connection string to production neon.com postgres database"
  type = string
  sensitive = true
}

variable "django_secret_key" {
  description = "Secret key for django web service."
  type = string
  sensitive = true
}

variable "django_health_check_secret" {
  description = "secret added after /health/ to prevent abuse in production."
  type = string
  sensitive = true
}

variable "django_email_backend" {
  description = "python module for django to use as email backend. Like django.core.mail.backends.console.EmailBackend for a dev env."
  type = string
  sensitive = false
}

variable "django_email_mailgun_api_key" {
  description = "API key for Mailgun ESP which Django will use to allow sending emails. Should be configured for the url the django app runs on."
  type = string
  sensitive = true
}

variable "stripe_secret_key_production" {
  description = "Stripe Secret Key for production"
  type        = string
  sensitive   = true
}
