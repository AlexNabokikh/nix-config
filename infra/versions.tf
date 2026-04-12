terraform {
  required_version = ">= 1.6"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.89.1"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
}
