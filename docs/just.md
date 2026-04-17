# Just Recipes

The `justfile` is the main operator interface for this repository.

List everything available:

```sh
just --list
```

Most recipes wrap their command with `doppler run --` so secrets and local
environment values are available consistently.

## Daily Mac Commands

`quick-update`
: Updates the flake lock, switches nix-darwin for the current hostname, then
switches Home Manager for `fs@<hostname>`.

`quick-update-macvm-fs`
: Same flow, pinned to `macvm-fs`.

`darwin-switch`
: Applies the nix-darwin configuration matching the current hostname.

`home-switch`
: Applies the Home Manager configuration matching `fs@<hostname>`.

`darwin-build` and `home-build`
: Build the current hostname's Darwin or Home Manager output without switching.

## Explicit Host Commands

Use these when the machine hostname does not match the flake output, or when
working from another host:

```sh
just darwin-switch-neo
just home-switch-neo
just darwin-switch-macvm-fs
just home-switch-macvm-fs
just darwin-build-macvm-fs
just home-build-macvm-fs
```

## Flake Management

`update`
: Runs `nix flake update`.

`verify-flake`
: Runs `nix flake check`.

`repl`
: Opens a Nix REPL for the current flake.

## Terraform

Terraform recipes run in the `infra/` directory.

```sh
just tf init
just tf plan
just tf apply
just tf output ssh_targets
```

Convenience wrappers:

```sh
just tf-init
just tf-upgrade
just tf-validate
```

## VM Deployment

`vm-build`
: Builds the NixOS Proxmox cloud image into `result-cloud/`. On Darwin, this
runs the Linux build inside Docker.

`vm-plan`
: Builds the cloud image, then runs Terraform plan.

`vm-apply`
: Builds the cloud image, uploads/imports it through Terraform, and applies VM
infrastructure changes.

`vm-recreate`
: Rebuilds the image and recreates selected managed VMs from it. At the moment
this only replaces `trinity`; `morpheus` is intentionally commented out.

`vm-wait <hostname>`
: Reads the host's SSH target from Terraform output and waits until SSH is
reachable.

`vm-switch <hostname>`
: Runs `nixos-rebuild switch` remotely against a Terraform-managed VM, then
attempts to bring up Tailscale SSH.

`vm-switch-all`
: Switches all currently enabled VM hosts. At the moment this switches
`trinity`; `morpheus` is intentionally commented out.

`vm-deploy`
: Full VM path: build image, apply Terraform, wait for SSH, and switch the VM
NixOS configuration.

`vm-redeploy`
: Recreate selected VMs from a fresh image, then switch their NixOS
configuration.

## Quality And Maintenance

```sh
just fmt
just lint
just lint-fix
just deadnix
just deadnix-fix
just install-hooks
just run-hooks
just check-pre-commit
just clean
```

Use `fmt` before commits. Use `run-hooks` or `check-pre-commit` when changing
flake structure, host modules, or docs that should pass repository checks.
