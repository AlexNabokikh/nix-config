locals {
  cloudflare_tunnel_id = var.cloudflare_create_tunnel ? try(cloudflare_zero_trust_tunnel_cloudflared.trinity[0].id, null) : var.cloudflare_tunnel_id

  cloudflare_manage_tunnel = var.cloudflare_enabled && (var.cloudflare_create_tunnel || var.cloudflare_tunnel_id != null)
  cloudflare_apps          = var.cloudflare_enabled ? var.cloudflare_apps : {}

  cloudflare_app_hostnames = {
    for key, app in local.cloudflare_apps :
    key => "${app.subdomain}.${var.cloudflare_zone_name}"
  }

  cloudflare_access_apps = {
    for key, app in local.cloudflare_apps :
    key => app
    if var.cloudflare_access_enabled && try(app.access_enabled, true)
  }

  cloudflare_access_bypass_apps = {
    for key, app in local.cloudflare_apps :
    key => app
    if try(app.access_bypass, false)
  }
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "trinity" {
  count = var.cloudflare_enabled && var.cloudflare_create_tunnel ? 1 : 0

  account_id = var.cloudflare_account_id
  name       = var.cloudflare_tunnel_name
  config_src = var.cloudflare_manage_tunnel_config ? "cloudflare" : "local"
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "trinity" {
  count = local.cloudflare_manage_tunnel ? 1 : 0

  account_id = var.cloudflare_account_id
  tunnel_id  = local.cloudflare_tunnel_id
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "trinity" {
  count = local.cloudflare_manage_tunnel && var.cloudflare_manage_tunnel_config ? 1 : 0

  account_id = var.cloudflare_account_id
  tunnel_id  = local.cloudflare_tunnel_id

  config = {
    ingress = [
      {
        service = "http://127.0.0.1:80"
      },
      {
        service = "http_status:404"
      }
    ]
  }
}

resource "cloudflare_dns_record" "app" {
  for_each = local.cloudflare_apps

  zone_id = var.cloudflare_zone_id
  name    = each.value.subdomain
  content = "${local.cloudflare_tunnel_id}.cfargotunnel.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_zero_trust_access_policy" "allow_emails" {
  count = var.cloudflare_enabled && var.cloudflare_access_enabled ? 1 : 0

  account_id = var.cloudflare_account_id
  name       = "Allow selected users"
  decision   = "allow"

  include = [
    for email in var.cloudflare_access_allowed_emails : {
      email = {
        email = email
      }
    }
  ]
}

resource "cloudflare_zero_trust_access_policy" "bypass" {
  count = var.cloudflare_enabled && length(local.cloudflare_access_bypass_apps) > 0 ? 1 : 0

  account_id = var.cloudflare_account_id
  name       = "Bypass public service hostnames"
  decision   = "bypass"

  include = [
    {
      everyone = {}
    }
  ]
}

resource "cloudflare_zero_trust_access_application" "app" {
  for_each = local.cloudflare_access_apps

  account_id = var.cloudflare_account_id
  type       = "self_hosted"
  name       = try(each.value.name, title(each.key))
  domain     = local.cloudflare_app_hostnames[each.key]

  policies = [
    {
      id         = cloudflare_zero_trust_access_policy.allow_emails[0].id
      precedence = 1
    }
  ]

  depends_on = [
    cloudflare_dns_record.app
  ]
}

resource "cloudflare_zero_trust_access_application" "bypass_app" {
  for_each = local.cloudflare_access_bypass_apps

  account_id = var.cloudflare_account_id
  type       = "self_hosted"
  name       = "${try(each.value.name, title(each.key))} Bypass"
  domain     = local.cloudflare_app_hostnames[each.key]

  policies = [
    {
      id         = cloudflare_zero_trust_access_policy.bypass[0].id
      precedence = 1
    }
  ]

  depends_on = [
    cloudflare_dns_record.app
  ]
}
