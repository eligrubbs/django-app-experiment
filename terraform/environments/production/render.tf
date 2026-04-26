
resource "render_registry_credential" "ghcr" {
  name       = "Registry Credentials for GHCR"
  registry   = "GITHUB"
  username   = var.ghcr_username
  auth_token = var.ghcr_auth_token
}


resource "render_project" "hairbrush" {
  name = "Hairbrush"
  environments = {
    "Production" : {
      name             = "Production"
      protected_status = "unprotected"
    },
  }

  depends_on = [ render_registry_credential.ghcr ]
}

locals {
  # Database connection info (derived from postgres resource)
  # db_host          = render_postgres.db.id
  # db_internal_host = render_postgres.db.id
  # db_port          = "5432"
  db_name          = "neon_db" # Name of database. Connection string
  # db_user          = render_postgres.db.database_user
  # db_password      = render_postgres.db.connection_info.password

  # Redis connection info
  # redis_host = render_redis.redis.id
  # redis_port = "6379"

  # Custom domain
  custom_domain = "hairbrush.eligrubbs.com"
}


###########################
# Production Render Service
###########################


# =============================================================================
# Service image data sources
#
# We read the current image digest from Render to avoid stale state in
# Terraform causing "unable to fetch image" errors on service updates.
#
# The service IDs are hardcoded because referencing module outputs would
# create a cyclic dependency (module -> data source -> module).
#
# This setup prevents terraform state from getting stale. It also implies the best way
# to deploy to production is to use the deploy hook url that render generates for the service
#
# First-time setup: create the services first without the data sources
# (use an image with a specific sha), then add the data sources with the
# service IDs from `terraform state show`.
# =============================================================================
# locals {
#   bootstrap_digest = "sha256:7392c0752d8f713faa606a3b62bc5b5c49c7fe56dcb3e543303e83752c297be2" # you
#   bootstrap_image_url = "ghcr.io/eligrubbs/django-app-experiment@latest" # the `latest` part is ignored
# }

locals {
  production_service_ids = {
    webapp = "srv-d7n5rlnlk1mc73b4ft50"
  }
}

data "render_web_service" "production_api" {
  id = local.production_service_ids["webapp"]
}


module "production" {
  source = "../../modules/render_service"

  environment            = "production"
  render_environment_id  = render_project.hairbrush.environments["Production"].id
  registry_credential_id = render_registry_credential.ghcr.id

  api_service_config = {
    image_url       = data.render_web_service.production_api.runtime_source.image.image_url
    # until I implement CD properly, I will do it manually
    # current: "sha256:57aaf25ed78cbe2f458fdf9ac81b605c98027435f6eff640f10e74aaa323d151" #
    image_digest    = data.render_web_service.production_api.runtime_source.image.digest
    custom_domains = [{name = local.custom_domain}]
    plan            = "starter"
    postgres_database = local.db_name
  }

  postgres_config = {
    connection_str = var.backend_neon_connection_str_prod
  }

  django_config = {
    secret_key = var.django_secret_key
    settings_module = "hairbrush.settings_production"
  }

  depends_on = [render_registry_credential.ghcr, render_project.hairbrush]

}


resource "cloudflare_dns_record" "api" {
  zone_id = "32d60f1e6a8c694e53a615c0178ea3da"
  name    = local.custom_domain
  type    = "CNAME"
  content = replace(module.production.webapp_service_url, "https://", "")
  proxied = true # I believe this is free
  ttl     = 1
  comment = "record mapping this domain to a render.com web service"
}
