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
