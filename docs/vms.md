# NixOS VMs

This page covers Proxmox VMs managed by Terraform, a generated NixOS cloud
image, and remote `nixos-rebuild`.

## Scope

The VM infrastructure lives in `infra/`.

It manages:

- Proxmox VM definitions declared in Terraform variables.
- The custom NixOS cloud image.
- Cloud-init networking for VM bootstrap.
- Cloudflare DNS, tunnel, and optional Access resources for exposed services.

It does not manage physical NixOS hosts.

## Active Hosts

The currently enabled VM deployment path targets `trinity`.

`morpheus` is intentionally commented out in the VM recipes while it is being
replaced by a physical NixOS device.

## Terraform Inputs

VM definitions live in:

```text
infra/management_variables.tf
```

Local secret values should come from `.envrc` or Doppler as `TF_VAR_...`
exports. After changing `.envrc`, run:

```sh
direnv allow
```

Reference templates:

```text
infra/proxmox.auto.tfvars.example
infra/secrets.auto.tfvars.example
```

## Normal Deploy

From the repository root:

```sh
just vm-deploy
```

This does four things:

1. Builds `result-cloud/nixos-proxmox-cloud.qcow2`.
2. Runs Terraform in `infra/` to upload/import the image and create/update VMs.
3. Waits until SSH is reachable.
4. Runs `nixos-rebuild switch` remotely for each enabled VM.

## Plan Infrastructure

```sh
just vm-plan
```

This builds the image first, then runs Terraform plan with `-parallelism=1`.

## Apply Infrastructure Only

```sh
just vm-apply
```

Use this when the image or Terraform-managed VM shape changed and you do not
need a full recreate.

## Recreate VMs From The Image

```sh
just vm-recreate
```

This currently replaces only `trinity`.

To re-enable another VM, update the `vm-recreate`, `vm-redeploy`, `vm-switch-all`,
and `vm-deploy` recipes in `justfile`, and make sure the host exists in both
Terraform and `flake.nix`.

## Switch NixOS Without Recreating

Switch one VM:

```sh
just vm-switch trinity
```

Switch all enabled VMs:

```sh
just vm-switch-all
```

## Inspect SSH Targets

Terraform exports the SSH targets used by `vm-wait` and `vm-switch`:

```sh
just tf output ssh_targets
```

Wait for one host:

```sh
just vm-wait trinity
```

## VM Host Config Shape

VM hosts such as `trinity` currently import:

```text
hosts/vm-generic/configuration.nix
```

That module assumes a Proxmox/QEMU environment:

- QEMU guest profile.
- `services.qemuGuest.enable = true`.
- cloud-init.
- static networking from Proxmox initialization.
- root filesystem at `/dev/disk/by-label/nixos`.
- EFI filesystem at `/dev/disk/by-label/ESP`.

Do not reuse this module directly for a physical machine.

## Cloud Image

The cloud image output is declared as `vm-cloud-image` in `flake.nix`.

On macOS, `just vm-build` uses Docker to build the Linux image. On Linux, it
runs `nix build` directly.
