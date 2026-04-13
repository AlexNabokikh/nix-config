resource "proxmox_virtual_environment_file" "nixos_cloud_image" {
  content_type = "import"
  datastore_id = var.iso_storage_pool
  node_name    = var.cloud_image_node

  source_file {
    path      = "${path.module}/../result-cloud/${var.cloud_image_file_name}"
    file_name = var.cloud_image_file_name
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  for_each = { for name, config in var.vms : name => config if config.enabled }

  name        = each.key
  description = "Terraform managed ${each.key} VM"
  node_name   = each.value.target_node
  vm_id       = each.value.vm_id
  bios        = "ovmf"
  machine     = "q35"
  boot_order  = ["virtio0"]
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

  disk {
    datastore_id = var.storage_pool
    file_format  = "qcow2"
    import_from  = proxmox_virtual_environment_file.nixos_cloud_image.id
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

  initialization {
    datastore_id = var.storage_pool

    dns {
      servers = each.value.dns
    }

    ip_config {
      ipv4 {
        address = each.value.ipv4_address != null && each.value.prefix_length != null ? "${each.value.ipv4_address}/${each.value.prefix_length}" : "dhcp"
        gateway = each.value.gateway
      }
    }
  }

  started = true

  lifecycle {
    ignore_changes = [
      disk[0].file_format,
    ]
  }
}
