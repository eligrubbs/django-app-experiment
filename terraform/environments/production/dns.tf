######
# DNS Records for Website DNS server managed by Cloudflare
#

#####
# Point Custom Domain to Render Service
#####

locals {
    cloudflare_dns_zone_id = "32d60f1e6a8c694e53a615c0178ea3da"
}

resource "cloudflare_dns_record" "api" {
  zone_id = local.cloudflare_dns_zone_id
  name    = local.custom_domain
  type    = "CNAME"
  content = replace(module.production.webapp_service_url, "https://", "")
  proxied = true # I believe this is free
  ttl     = 1
  comment = "record mapping this domain to a render.com web service"
}


#####
# Email Setup
#
# Following Mailgun's setup guide to get email sending configured on the subdomain
#
#####

resource "cloudflare_dns_record" "email_txt_spf" {
    zone_id = local.cloudflare_dns_zone_id
    name = local.custom_domain
    type = "TXT"
    content = "v=spf1 include:mailgun.org ~all"
    ttl = 1
    comment = "part of mailgun's guide for manual domain verification"
}

resource "cloudflare_dns_record" "email_txt_dkim" {
    zone_id = local.cloudflare_dns_zone_id
    name = "mx._domainkey.${local.custom_domain}"
    type = "TXT"
    content = "k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDahKxOjwMDiQijvBd3bYqFq88H3b1akaxzsHwTr78Tlw+1d8Lu0BbOGAVdUnuyVBwCY3GhEgy7Xw9MxF8DZ0RUvsak5lxFDhWYXu1v1XpqrokkMTtVCvycQhEK7hy5S1caPMp5O7xYeAMKWsX3A+ZbmnG5ZYp8AB0T9vsW2AnCSwIDAQAB"
    ttl = 1
    comment = "part of mailgun's guide for manual domain verification"
}

resource "cloudflare_dns_record" "email_mxa" {
    zone_id = local.cloudflare_dns_zone_id
    name = local.custom_domain
    type = "MX"
    content = "mxa.mailgun.org"
    ttl = 1
    priority = 10
    comment = "part of mailgun's guide for manual domain verification"
}

resource "cloudflare_dns_record" "email_mxb" {
    zone_id = local.cloudflare_dns_zone_id
    name = local.custom_domain
    type = "MX"
    content = "mxb.mailgun.org"
    ttl = 1
    priority = 10
    comment = "part of mailgun's guide for manual domain verification"
}

resource "cloudflare_dns_record" "email_cname" {
    zone_id = local.cloudflare_dns_zone_id
    name = "email.${local.custom_domain}"
    type = "CNAME"
    content = "mailgun.org"
    ttl = 1
    comment = "part of mailgun's guide for manual domain verification"
}

resource "cloudflare_dns_record" "email_txt_dmarc" {
    zone_id = local.cloudflare_dns_zone_id
    name = "_dmarc.${local.custom_domain}"
    type = "TXT"
    content = "v=DMARC1; p=none; pct=100; fo=1; ri=3600; rua=mailto:f23d1012@dmarc.mailgun.org,mailto:f7b1fbeb@inbox.ondmarc.com; ruf=mailto:f23d1012@dmarc.mailgun.org,mailto:f7b1fbeb@inbox.ondmarc.com;"
    ttl = 1
    comment = "part of mailgun's guide for manual domain verification"
}
