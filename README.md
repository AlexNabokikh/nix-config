# Nix Home Machines

Personal Nix configurations for macOS, NixOS VMs, and physical NixOS hosts.

This repository is managed through flakes and `just`. The root README is the
map; operational details live in the linked pages below.

## Start Here

- [Mac deployment](docs/mac.md): install Nix, apply nix-darwin, and switch Home Manager.
- [Just recipes](docs/just.md): what the `justfile` commands do and when to use them.
- [NixOS VMs](docs/vms.md): build and deploy Proxmox cloud-image VMs.
- [Physical NixOS hosts](docs/physical-hosts.md): add and install physical machines.

## Current Machines

System outputs are declared in `flake.nix`.

- `neo`: macOS host.
- `macvm-fs`: macOS VM host.
- `nixos`: NixOS host profile.
- `trinity`: Proxmox NixOS VM.
- `morpheus`: currently being moved away from the VM deployment path.

Home Manager outputs use the `user@host` shape, for example `fs@neo` and
`fs@trinity`.

## Common Commands

```sh
just --list
just quick-update
just darwin-switch
just home-switch
just vm-deploy
just fmt
just check-pre-commit
```

Most commands run through Doppler because this repo expects secrets and local
environment values to come from there.

## Repository Layout

```text
.
├── flake.nix          # flake inputs and host/home outputs
├── justfile           # task runner for deploys, builds, checks, and formatting
├── hosts/             # system-level host configurations
├── home/              # Home Manager configurations
├── users/             # user identity and SSH key data
├── infra/             # Terraform for Proxmox VM infrastructure
├── files/             # static assets and screenshots
├── overlays/          # package overlays
└── docs/              # operational notes and guides
```

## Useful Reference Docs

- [Adding Machines](docs/ADDING-MACHINES.md)
- [Manual Installs](docs/ManualInstalls.md)
- [Pre-commit Hooks](docs/PRE-COMMIT.md)
- [Aerospace](docs/darwin-aerospace.md)
- [tmux](docs/tmux.md)

## Maintenance

```sh
just update
just verify-flake
just fmt
just run-hooks
just clean
```

The repo is intentionally personal. Use it as a working source of truth for
these machines rather than a generic NixOS template.
