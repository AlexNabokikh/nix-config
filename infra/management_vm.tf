resource "proxmox_virtual_environment_vm" "vm" {
  for_each = { for name, config in var.vms : name => config if config.enabled }

  name        = each.key
  description = "Terraform managed ${each.key} VM"
  node_name   = each.value.target_node
  vm_id       = each.value.vm_id
  bios        = "ovmf"
  machine     = "q35"
  boot_order  = ["ide2", "virtio0"]
  on_boot     = true

  agent {
    enabled = true
    timeout = "5m"
  }

  cpu {
    cores   = each.value.cpu_cores
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = each.value.memory_mb
  }

  efi_disk {
    datastore_id      = var.storage_pool
    file_format       = "raw"
    type              = "4m"
    pre_enrolled_keys = false
  }

  vga {
    type = "std"
  }

  cdrom {
    enabled   = true
    file_id   = "${var.iso_storage_pool}:iso/${each.key}-nixos-installer.iso"
    interface = "ide2"
  }

  disk {
    datastore_id = var.storage_pool
    interface    = "virtio0"
    size         = each.value.disk_size_gb
    iothread     = true
  }

  network_device {
    bridge = var.management_vm_bridge
    model  = "virtio"
  }

  operating_system {
    type = "l26"
  }

  started = true
}
