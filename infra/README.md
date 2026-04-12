# Proxmox VM Infrastructure

This directory manages the Proxmox NixOS VMs declared in `var.vms`.

It intentionally does not manage the Talos Kubernetes cluster, Cloudflare
tunnels, or Doppler resources from the original Kubernetes repository.

## Usage

From the repository root:

```sh
just tf init
just tf plan
```

To build the custom NixOS cloud image, upload/import it through Terraform, create
the VMs with Proxmox cloud-init static networking, and apply the host-specific
NixOS configs:

```sh
just vm-deploy
```

`just vm-deploy` builds `result-cloud/nixos-proxmox-cloud.qcow2`, then Terraform
uploads that image to the shared Proxmox ISO/import datastore and creates the VMs
from it. Terraform names each VM and its `initialization` block sets DNS,
gateway, and static IP address through Proxmox cloud-init. After SSH becomes
reachable, the recipe runs `nixos-rebuild switch` for each host.

The VM IPs live in `infra/management_variables.tf` or local `*.tfvars`
overrides. Use Terraform outputs to inspect the current targets:

```sh
just tf output ssh_targets
```

If you only need to rebuild the image and update infrastructure:

```sh
just vm-apply
```

If you only need to re-apply the NixOS configs:

```sh
just vm-switch-all
```

Local values live in ignored `*.tfvars` files. Use the committed examples as
templates:

- `proxmox.auto.tfvars.example`
- `secrets.auto.tfvars.example`
