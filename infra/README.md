# Trinity Infrastructure

This directory manages only Trinity, the standalone Proxmox management VM.

It intentionally does not manage the Talos Kubernetes cluster, Cloudflare
tunnels, or Doppler resources from the original Kubernetes repository.

## Usage

From the repository root:

```sh
just tf init
just tf plan
```

To build Trinity from a NixOS ISO instead of cloning a Debian template:

```sh
just management-bootstrap
```

That command builds the custom `trinity-installer` ISO from this flake, uploads
it to the Proxmox ISO store, creates a blank OVMF VM, waits for SSH on the live
installer, runs `nixos-anywhere --flake .#trinity`, then ejects the ISO and
switches the VM back to disk boot. The Trinity configuration imports
`hosts/trinity/disko.nix`, so `nixos-anywhere` owns the disk partitioning and
formatting step.

The live installer is SSHable as `root@10.0.40.100` for `nixos-anywhere`. The
installed Trinity system is SSHable as `fs@10.0.40.100`.

If you only need to rebuild/upload the installer ISO:

```sh
just management-upload-installer-iso pve-2 nfs-proxmox-iso trinity-nixos-installer.iso
```

If you need to rerun only the install from an already booted installer:

```sh
just management-install-nixos
just management-finalize
```

Local values live in ignored `*.tfvars` files. Use the committed examples as
templates:

- `proxmox.auto.tfvars.example`
- `secrets.auto.tfvars.example`
