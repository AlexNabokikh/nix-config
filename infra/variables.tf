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
  description = "Deprecated compatibility variable. Static networking now lives in hosts/trinity/configuration.nix."
  type        = string
  default     = "10.0.40.1"
}

variable "storage_pool" {
  description = "Proxmox storage pool for VM disks"
  type        = string
  default     = "ceph-proxmox-rbd"
}

variable "iso_storage_pool" {
  description = "Proxmox storage pool for NixOS installer ISOs"
  type        = string
  default     = "nfs-proxmox-iso"
}
