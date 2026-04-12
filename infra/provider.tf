provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  insecure  = var.proxmox_insecure
  api_token = "${var.proxmox_token_id}=${var.proxmox_token_secret}"
}
