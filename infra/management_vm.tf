resource "proxmox_virtual_environment_vm" "management_vm" {
  count = var.management_vm_enabled ? 1 : 0

  name        = var.management_vm_name
  description = var.management_vm_description
  node_name   = var.management_vm_target_node
  vm_id       = var.management_vm_id
  bios        = "ovmf"
  machine     = "q35"
  boot_order  = ["ide2", "virtio0"]
  on_boot     = true

  agent {
    enabled = true
    timeout = "5m"
  }

  cpu {
    cores   = var.management_vm_cpu_cores
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = var.management_vm_memory_mb
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
    file_id   = var.management_vm_iso_path
    interface = "ide2"
  }

  disk {
    datastore_id = var.storage_pool
    interface    = "virtio0"
    size         = var.management_vm_disk_size_gb
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
