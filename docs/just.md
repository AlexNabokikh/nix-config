# Just Recipes

The `justfile` is the main operator interface for this repository.

List everything available:

```sh
just --list
```

Most recipes wrap their command with `doppler run --` so secrets and local
environment values are available consistently.

## Daily Commands

`quick-update`
: Updates the flake lock, then switches every enabled deployment lane:
`darwin-switch`, `nixos-switch`, and `vm-switch`.

Aggregate recipes are best-effort per host. If a physical host or VM is
offline, the aggregate command prints a skip message for that host and continues
with the remaining lanes. Explicit host commands such as
`just nixos-switch morpheus` still fail when that host cannot be reached.

Long-running recipes print colored section banners so the `quick-update` output
is easier to scan. Flake/update steps are yellow, Darwin is cyan, Home Manager
is blue, physical NixOS hosts are green, and VMs are magenta.

Current enabled targets:

| Lane | Default Targets | What It Switches |
|------|-----------------|------------------|
| `darwin-*` | `neo` | nix-darwin plus `fs@neo` Home Manager |
| `nixos-*` | `morpheus` | Physical NixOS host plus `fs@morpheus` Home Manager over SSH |
| `vm-*` | `trinity` | Terraform-managed NixOS VM plus `fs@trinity` Home Manager over SSH |

`home-switch`
: Keeps the old local muscle memory. It switches Home Manager for the current
hostname, or for an explicit host with `just home-switch <hostname>`.

`quick-update-lane <lane>`
: Updates the flake lock, then switches one lane. Valid lanes are `darwin`,
`nixos`, and `vm`.

## Darwin Hosts

Darwin recipes target all enabled Macs by default. Pass a hostname to target one
Mac.

```sh
just darwin-switch
just darwin-switch neo
just darwin-build
just darwin-build neo
just darwin-home-switch
just darwin-home-switch neo
just darwin-home-build
just darwin-home-build neo
```

`darwin-switch`
: Applies nix-darwin, then applies the matching Home Manager output.

`darwin-build`
: Builds nix-darwin, then builds the matching Home Manager output.

`darwin-home-switch` and `darwin-home-build`
: Run only the Home Manager half of the Darwin lane.

Compatibility aliases remain for older habits:

```sh
just darwin-switch-neo
just home-switch-neo
just darwin-switch-macvm-fs
just home-switch-macvm-fs
just darwin-build-macvm-fs
just home-build-macvm-fs
```

## Physical NixOS Hosts

Physical NixOS recipes target all enabled physical hosts by default. Pass a
hostname to target one host.

```sh
just nixos-build
just nixos-build morpheus
just nixos-switch
just nixos-switch morpheus
just nixos-home-build
just nixos-home-build morpheus
just nixos-home-switch
just nixos-home-switch morpheus
```

`nixos-build`
: Builds the physical host remotely with `nixos-rebuild build`, then builds the
matching Home Manager activation package.

`nixos-switch`
: Switches the physical host remotely with `nixos-rebuild switch`, tries to
authenticate Tailscale with `TAILSCALE_AUTH_KEY` if that secret is available,
then switches the matching Home Manager profile.

`nixos-home-build`
: Builds only the physical host's Home Manager activation package. Linux Home
Manager outputs are built on the physical host itself, so this works when
driven from an Apple Silicon Mac.

`nixos-home-switch`
: Archives the current flake to the physical host, builds the Home Manager
activation package there, then runs the activation script as `fs`.

Both physical NixOS recipes check SSH reachability before starting the remote
build or switch. If `10.0.40.19` is unreachable, run them from the same LAN/VPN
as Morpheus, or use a reachable Tailscale target once the host has joined
Tailscale.

Physical host SSH targets are resolved in private recipes in the `justfile`. At
the moment, `morpheus` resolves to `root@10.0.40.19` for system operations and
`fs@10.0.40.19` for Home Manager activation.

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

`just tf` runs Terraform through `doppler run --name-transformer tf-var --`, so
uppercase Doppler keys such as `PROXMOX_TOKEN_SECRET` and `CLOUDFLARE_API_TOKEN`
are exposed as Terraform's expected `TF_VAR_...` environment variables.

## VM Deployment

`vm-build`
: Builds the NixOS Proxmox cloud image into `result-cloud/`. On Darwin, this
runs the Linux build inside Docker.

`vm-plan`
: Builds the cloud image, then runs Terraform plan.

`vm-apply`
: Builds the cloud image, uploads/imports it through Terraform, and applies VM
infrastructure changes.

`vm-recreate <hostname>`
: Rebuilds the image and recreates one Terraform-managed VM from it. The
default host is `trinity`.

`vm-wait <hostname>`
: Reads the host's SSH target from Terraform output and waits until SSH is
reachable.

`vm-switch`
: Switches all enabled VM hosts. At the moment this switches `trinity`.

`vm-switch <hostname>`
: Runs `nixos-rebuild switch` remotely against one Terraform-managed VM, then
attempts to bring up Tailscale SSH, then switches the matching Home Manager
profile.

`vm-home-build`
: Builds Home Manager activation packages for all enabled VM hosts.

`vm-home-build <hostname>`
: Archives the current flake to one VM and builds its Home Manager activation
package there.

`vm-home-switch`
: Switches Home Manager on all enabled VM hosts.

`vm-home-switch <hostname>`
: Archives the current flake to one VM, builds the Home Manager activation
package there, then runs the activation script as `fs`.

`vm-switch-all`
: Compatibility alias for `vm-switch`.

`vm-home-switch-all` and `vm-home-build-all`
: Compatibility aliases for the all-host VM Home Manager recipes.

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
