# Physical NixOS Hosts

This page covers adding and installing physical NixOS machines.

Physical hosts should not import the VM module from `hosts/vm-generic/`. That
module is built for Proxmox/QEMU cloud-image machines.

## Recommended Shape

Create a host directory:

```text
hosts/<hostname>/
├── configuration.nix
└── hardware-configuration.nix
```

A typical physical host configuration looks like this:

```nix
{
  inputs,
  hostname,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix

    ../modules/nixos-common.nix
  ];

  networking.hostName = hostname;

  system.stateVersion = "25.05";
}
```

Add hardware-specific modules as needed:

```nix
inputs.hardware.nixosModules.common-cpu-amd
inputs.hardware.nixosModules.common-gpu-amd
inputs.hardware.nixosModules.common-cpu-intel
```

Add desktop modules only when the host needs them:

```nix
../modules/gnome.nix
../modules/hyprland.nix
../modules/laptop.nix
../modules/steam.nix
```

## Add The Flake Outputs

In `flake.nix`, add a system output:

```nix
nixosConfigurations = {
  "<hostname>" = mkNixosConfiguration "<hostname>" "fs";
};
```

Add a Home Manager output:

```nix
homeConfigurations = {
  "fs@<hostname>" = mkHomeConfiguration "x86_64-linux" "fs" "<hostname>";
};
```

Then create:

```text
home/fs/<hostname>.nix
```

## Install Option 1: Minimal ISO, Then Switch

This is the most conservative path.

1. Boot the NixOS minimal ISO on the physical machine.
2. Partition and install a basic NixOS system.
3. Enable SSH.
4. Clone this repository.
5. Generate hardware config for the physical machine.
6. Switch to the flake.

Generate hardware configuration:

```sh
sudo nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix
```

Switch system config:

```sh
sudo nixos-rebuild switch --flake .#<hostname>
```

Switch Home Manager:

```sh
home-manager switch --flake .#fs@<hostname>
```

This path is a little longer, but it lets NixOS discover the correct disks,
filesystems, kernel modules, and hardware details before the flake takes over.

## Install Option 2: Installer ISO And Remote Switch

This is useful when the machine is already reachable over SSH from another host.

On the target machine, boot the NixOS installer ISO and start SSH:

```sh
sudo systemctl start sshd
passwd
ip addr
```

From your workstation, copy or clone this repo, prepare the host config, then
install/switch remotely with `nixos-rebuild` or `nixos-anywhere`.

## Install Option 3: `nixos-anywhere`

This is the shortest clean install once the repo has a physical disk layout for
the host.

Requirements:

- The target is booted into a NixOS installer environment.
- SSH works to the target.
- The host has a physical-safe `disko` config.
- The flake output builds for the host.

Example:

```sh
nix run github:nix-community/nixos-anywhere -- \
  --flake .#<hostname> \
  root@<target-ip>
```

Use this only after checking the target disk name carefully. A physical disko
file may format the whole disk.

## Disk Config

For manual installs, let `nixos-generate-config` create
`hardware-configuration.nix`.

For `nixos-anywhere`, add a host-specific `disko.nix` and import the disko module
in the host configuration:

```nix
{
  inputs,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    ./disko.nix
    ./hardware-configuration.nix
    ../modules/nixos-common.nix
  ];
}
```

Do not reuse the existing VM disko file for a physical host. It targets
`/dev/vda`, which is the usual virtual disk name, not the usual physical disk
name.

## Replacing `morpheus`

`morpheus` is currently being removed from the VM deployment path. To make it a
physical host:

1. Rework `hosts/morpheus/configuration.nix` so it imports physical modules,
not `../vm-generic/configuration.nix`.
2. Generate or write `hosts/morpheus/hardware-configuration.nix`.
3. Re-enable `morpheus` in `nixosConfigurations` in `flake.nix`.
4. Keep it out of the VM recipes unless it becomes a Proxmox VM again.
5. Add or keep `home/fs/morpheus.nix` and the `fs@morpheus` Home Manager output.

The important rule: physical `morpheus` should be deployed with NixOS tooling,
not Terraform VM recipes.
