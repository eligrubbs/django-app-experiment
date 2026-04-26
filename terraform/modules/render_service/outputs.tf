output "webapp_service_url" {
  description = "The URL of the API service (used as CNAME target for custom domains)"
  value       = render_web_service.webapp.url
}

output "webapp_service_id" {
  description = "The ID of the API service"
  value       = render_web_service.webapp.id
}

output "webapp_image_url" {
  description = "The URL of the image currently running on the API service"
  value       = render_web_service.webapp.runtime_source.image.image_url
}
