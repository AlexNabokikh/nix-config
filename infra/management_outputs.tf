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
