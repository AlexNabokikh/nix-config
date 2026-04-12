output "vms" {
  description = "Deployed VMs details"
  value = {
    for name, vm in proxmox_virtual_environment_vm.vm : name => {
      name      = vm.name
      vm_id     = vm.vm_id
      node_name = vm.node_name
      ipv4      = try(var.vms[name].ipv4_address, "DHCP")
      username  = var.management_vm_username
    }
  }
}

output "installer_targets" {
  description = "SSH targets for nixos-anywhere installer (use with just vm-install)"
  value = {
    for name, config in var.vms : name => {
      target  = config.ipv4_address != null ? "root@${config.ipv4_address}" : "DHCP_PENDING"
      ssh_key = config.nixos_anywhere_identity_file
      vm_id   = config.vm_id
      node    = config.target_node
    }
  }
  sensitive = false
}
