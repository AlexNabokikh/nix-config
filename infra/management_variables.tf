variable "management_vm_enabled" {
  description = "Whether to create the standalone management VM"
  type        = bool
  default     = true
}

variable "management_vm_name" {
  description = "Management VM name"
  type        = string
  default     = "trinity"
}

variable "management_vm_description" {
  description = "Management VM description"
  type        = string
  default     = "Terraform managed management VM"
}

variable "management_vm_target_node" {
  description = "Proxmox node where the management VM should run"
  type        = string
  default     = "pve-2"
}

variable "management_vm_id" {
  description = "Proxmox VM ID for the management VM"
  type        = number
  default     = 4100
}

variable "management_vm_ipv4_address" {
  description = "Static IPv4 address for the management VM. Keep this in sync with hosts/trinity/configuration.nix."
  type        = string
  default     = "10.0.40.100"
}

variable "management_vm_cidr_prefix" {
  description = "Deprecated compatibility variable. Static networking now lives in hosts/trinity/configuration.nix."
  type        = number
  default     = 24
}

variable "management_vm_cpu_cores" {
  description = "CPU cores assigned to the management VM"
  type        = number
  default     = 4
}

variable "management_vm_memory_mb" {
  description = "Dedicated memory assigned to the management VM in MB"
  type        = number
  default     = 8192
}

variable "management_vm_disk_size_gb" {
  description = "Primary disk size for the management VM in GB"
  type        = number
  default     = 40
}

variable "management_vm_bridge" {
  description = "Primary network bridge for the management VM"
  type        = string
  default     = "vmbr0"
}

variable "management_vm_username" {
  description = "Primary operating system user for the management VM"
  type        = string
  default     = "fs"
}

variable "management_vm_dns_servers" {
  description = "Deprecated compatibility variable. Static DNS now lives in hosts/trinity/configuration.nix."
  type        = list(string)
  default     = ["1.1.1.1", "1.0.0.1"]
}

variable "management_vm_nixos_anywhere_enabled" {
  description = "Whether Terraform should run nixos-anywhere after creating the ISO-booted management VM. This overwrites the VM disk."
  type        = bool
  default     = true
}

variable "management_vm_nixos_anywhere_flake" {
  description = "Flake reference passed to nixos-anywhere for the management VM"
  type        = string
  default     = ".#trinity"
}

variable "management_vm_nixos_anywhere_target" {
  description = "SSH target passed to nixos-anywhere for the NixOS installer environment"
  type        = string
  default     = "root@10.0.40.100"
}

variable "management_vm_nixos_anywhere_identity_file" {
  description = "SSH private key file passed to nixos-anywhere for the NixOS installer environment"
  type        = string
  default     = "~/.ssh/id_macbook_fs"
}

variable "management_vm_iso_path" {
  description = "Proxmox ISO file ID for the custom Trinity installer ISO (storage:iso/file.iso format)"
  type        = string
  default     = "nfs-proxmox-iso:iso/trinity-nixos-installer.iso"
}
