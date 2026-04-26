
output "render_web_service_image_url" {
    description = "the url of the apps' running image."
    value = module.production.webapp_image_url
}
