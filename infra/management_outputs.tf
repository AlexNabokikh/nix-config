output "management_vm" {
  description = "Management VM details"
  value = var.management_vm_enabled ? {
    name      = proxmox_virtual_environment_vm.management_vm[0].name
    vm_id     = proxmox_virtual_environment_vm.management_vm[0].vm_id
    node_name = proxmox_virtual_environment_vm.management_vm[0].node_name
    ipv4      = var.management_vm_ipv4_address
    username  = var.management_vm_username
  } : null
}
