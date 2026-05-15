locals {
  environment = var.environment
}

resource "render_web_service" "webapp" {
    name               = "webapp-${local.environment}"
    plan               = "starter"
    region             = "ohio"
    environment_id     = var.render_environment_id
    health_check_path  = "/health/${var.api_service_config.health_check_secret}"
    pre_deploy_command = "./deploy/pre-deploy.sh"
    start_command = "./deploy/start.sh"

    runtime_source = {
      image = {
        image_url              = split("@", var.api_service_config.image_url)[0]
        registry_credential_id = var.registry_credential_id
        digest                 = var.api_service_config.image_digest
      }
    }

    custom_domains = var.api_service_config.custom_domains

    env_vars = {
      ENV                               = { value = local.environment }
      SECRET_KEY                        = { value = var.django_config.secret_key }
      DJANGO_SETTINGS_MODULE            = { value = var.django_config.settings_module }
      FOR_DJANGO_POSTGRES_DB            = { value = var.api_service_config.postgres_database }
      FOR_DJANGO_POSTGRES_HOST          = { value = var.postgres_config.host }
      FOR_DJANGO_POSTGRES_PORT          = { value = var.postgres_config.port }
      FOR_DJANGO_POSTGRES_USER          = { value = var.postgres_config.user }
      FOR_DJANGO_POSTGRES_PASSWORD      = { value = var.postgres_config.password }
      FOR_DJANGO_DATABASE_URL           = { value = var.postgres_config.connection_str }
      FOR_DJANGO_HEALTH_CHECK_SECRET    = { value = var.api_service_config.health_check_secret }
      FOR_DJANGO_EMAIL_BACKEND          = { value = var.django_config.email_backend }
      FOR_DJANGO_MAILGUN_API_KEY        = { value = var.django_config.email_mailgun_api_key }
      FOR_DJANGO_MAILGUN_SENDER_DOMAIN  = { value = var.django_config.email_mailgun_sender_domain }
      FOR_DJANGO_STRIPE_TEST_SECRET_KEY = { value = var.stripe_secrets.secret_key } # TODO: When you use stripe for real
    }
}
