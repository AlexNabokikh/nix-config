# VMs to deploy
variable "vms" {
  description = "Map of VM configurations"
  type = map(object({
    enabled       = optional(bool, true)
    target_node   = string
    vm_id         = number
    cpu_cores     = optional(number, 4)
    memory_mb     = optional(number, 8192)
    disk_size_gb  = optional(number, 40)
    ipv4_address  = optional(string, null) # null = DHCP
    prefix_length = optional(number, null)
    gateway       = optional(string, null)
    dns           = optional(list(string), [])
  }))
  default = {
    trinity = {
      target_node   = "pve-2"
      vm_id         = 4061
      cpu_cores     = 4
      memory_mb     = 8192
      disk_size_gb  = 40
      ipv4_address  = "10.0.40.61"
      prefix_length = 24
      gateway       = "10.0.40.1"
      dns           = ["1.1.1.1", "1.0.0.1"]
    }
    # morpheus = {
    #   target_node   = "pve-1"
    #   vm_id         = 4062
    #   cpu_cores     = 4
    #   memory_mb     = 8192
    #   disk_size_gb  = 40
    #   ipv4_address  = "10.0.40.62"
    #   prefix_length = 24
    #   gateway       = "10.0.40.1"
    #   dns           = ["1.1.1.1", "1.0.0.1"]
    # }
  }
}

# Shared VM configuration defaults
variable "management_vm_bridge" {
  description = "Primary network bridge for VMs"
  type        = string
  default     = "vmbr0"
}

variable "management_vm_username" {
  description = "Primary operating system user for VMs"
  type        = string
  default     = "fs"
}

variable "cloud_image_node" {
  description = "Proxmox node used to upload the NixOS cloud image to shared storage"
  type        = string
  default     = "pve-2"
}

variable "cloud_image_file_name" {
  description = "File name for the uploaded NixOS cloud image"
  type        = string
  default     = "nixos-proxmox-cloud.qcow2"
}
