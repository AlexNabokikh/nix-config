# VMs to deploy
variable "vms" {
  description = "Map of VM configurations"
  type = map(object({
    enabled                  = optional(bool, true)
    target_node              = string
    vm_id                    = number
    cpu_cores                = optional(number, 4)
    memory_mb                = optional(number, 8192)
    disk_size_gb             = optional(number, 40)
    ipv4_address             = optional(string, null) # null = DHCP
    nixos_anywhere_enabled   = optional(bool, true)
    nixos_anywhere_target    = optional(string)        # defaults to root@{ipv4_address} or DHCP discovery
    nixos_anywhere_identity_file = optional(string, "~/.ssh/id_macbook_fs")
  }))
  default = {
    trinity = {
      target_node  = "pve-2"
      vm_id        = 4100
      ipv4_address = "10.0.40.100"
      cpu_cores    = 4
      memory_mb    = 8192
      disk_size_gb = 40
    }
    morpheus = {
      target_node  = "pve-2"
      vm_id        = 4101
      cpu_cores    = 4
      memory_mb    = 8192
      disk_size_gb = 40
      nixos_anywhere_enabled = false
    }
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
