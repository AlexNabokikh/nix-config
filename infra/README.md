# Proxmox VM Infrastructure

This directory manages the Proxmox NixOS VMs declared in `var.vms` and the
Cloudflare DNS, tunnel, and optional Access resources for the exposed services.

It intentionally does not manage the Talos Kubernetes cluster or Doppler
resources from the original Kubernetes repository.

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

The VM IPs live in `infra/management_variables.tf` or local `TF_VAR_`
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

Local secret values live in `.envrc` as `TF_VAR_...` exports. Run `direnv allow`
after changing `.envrc`, then use the normal `just tf ...` recipes.

The committed examples are only reference templates:

- `proxmox.auto.tfvars.example`
- `secrets.auto.tfvars.example`
