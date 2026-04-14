variable "proxmox_endpoint" {
  description = "Proxmox API endpoint URL"
  type        = string
}

variable "proxmox_insecure" {
  description = "Skip TLS verification for the Proxmox API"
  type        = bool
  default     = false
}

variable "proxmox_node" {
  description = "Default Proxmox node name"
  type        = string
}

variable "proxmox_token_id" {
  description = "Proxmox API token ID"
  type        = string
  sensitive   = true
}

variable "proxmox_token_secret" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
}

variable "gateway" {
  description = "Deprecated compatibility variable. VM networking now lives in var.vms and is applied by Proxmox cloud-init."
  type        = string
  default     = "10.0.40.1"
}

variable "storage_pool" {
  description = "Proxmox storage pool for VM disks"
  type        = string
  default     = "ceph-proxmox-rbd"
}

variable "iso_storage_pool" {
  description = "Proxmox storage pool for the uploaded NixOS cloud image"
  type        = string
  default     = "nfs-proxmox-iso"
}

variable "cloudflare_enabled" {
  description = "Whether Terraform should manage Cloudflare DNS and Access resources."
  type        = bool
  default     = false
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token with permissions to manage DNS, tunnels, and Access apps."
  type        = string
  sensitive   = true
  default     = null
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID."
  type        = string
  sensitive   = true
  default     = null
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID for the public zone."
  type        = string
  sensitive   = true
  default     = null
}

variable "cloudflare_zone_name" {
  description = "Cloudflare zone name used to build application hostnames."
  type        = string
  default     = "krapulax.dev"
}

variable "cloudflare_tunnel_id" {
  description = "Existing Cloudflare Tunnel UUID that cloudflared on trinity connects to."
  type        = string
  default     = null
}

variable "cloudflare_create_tunnel" {
  description = "Whether Terraform should create the Cloudflare Tunnel instead of using cloudflare_tunnel_id."
  type        = bool
  default     = false
}

variable "cloudflare_tunnel_name" {
  description = "Cloudflare Tunnel name to create when cloudflare_create_tunnel is true."
  type        = string
  default     = "trinity"
}

variable "cloudflare_manage_tunnel_config" {
  description = "Whether Terraform should manage the Cloudflare Tunnel's remote catch-all ingress to Traefik."
  type        = bool
  default     = false
}

variable "cloudflare_access_enabled" {
  description = "Whether to create Cloudflare Access applications and policies for enabled apps."
  type        = bool
  default     = false
}

variable "cloudflare_access_allowed_emails" {
  description = "Email addresses allowed through Cloudflare Access when access is enabled."
  type        = list(string)
  default     = []
}

variable "cloudflare_apps" {
  description = "Applications exposed through the trinity Cloudflare tunnel and Traefik Docker labels."
  type = map(object({
    subdomain      = string
    name           = optional(string)
    access_enabled = optional(bool, true)
    access_bypass  = optional(bool, false)
  }))
  default = {
    arcane = {
      subdomain = "arcane"
      name      = "Arcane"
    }
    beszel = {
      subdomain = "beszel"
      name      = "Beszel"
    }
    omni = {
      subdomain      = "omni"
      name           = "Omni"
      access_enabled = false
      access_bypass  = true
    }
    omni_auth = {
      subdomain      = "auth"
      name           = "Omni Auth"
      access_enabled = false
      access_bypass  = true
    }
    whoami = {
      subdomain      = "whoami"
      name           = "Whoami"
      access_enabled = false
    }
  }
}
