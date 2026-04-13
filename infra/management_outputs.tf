output "vms" {
  description = "Deployed VMs details"
  value = {
    for name, vm in proxmox_virtual_environment_vm.vm : name => {
      name      = vm.name
      vm_id     = vm.vm_id
      node_name = vm.node_name
      ipv4      = try(var.vms[name].ipv4_address, "DHCP")
      gateway   = try(var.vms[name].gateway, null)
      username  = var.management_vm_username
    }
  }
}

output "ssh_targets" {
  description = "SSH targets for deployed NixOS cloud-image VMs"
  value = {
    for name, config in var.vms : name => {
      target = config.ipv4_address != null ? "${var.management_vm_username}@${config.ipv4_address}" : "DHCP_PENDING"
      vm_id  = config.vm_id
      node   = config.target_node
    }
  }
  sensitive = false
}

output "cloudflare_app_hostnames" {
  description = "Cloudflare app hostnames routed to the trinity tunnel"
  value       = local.cloudflare_app_hostnames
}

output "cloudflare_tunnel_id" {
  description = "Cloudflare Tunnel ID used by the app DNS records"
  value       = local.cloudflare_tunnel_id
}

output "cloudflare_tunnel_token" {
  description = "Cloudflare Tunnel run token for cloudflared"
  value       = try(data.cloudflare_zero_trust_tunnel_cloudflared_token.trinity[0].token, null)
  sensitive   = true
}
