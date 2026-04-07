# NixOS and nix-darwin Configurations for My Machines

This repository contains my NixOS and nix-darwin configurations, managed through Nix Flakes.

It is designed for:

- NixOS machines
- macOS machines through `nix-darwin`
- user-level configuration through `home-manager`

The repo follows a hybrid dendritic pattern.

In practice, that means:

- small modules do one thing
- branch modules group related settings
- stacks combine reusable modules into host-level choices
- hosts stay short and easy to read

The simplest mental model is:

- `hosts/` = real machines
- `modules/` = reusable building blocks
- `modules/stacks/` = convenient bundles of those building blocks
- `modules/profile/` = personal settings shared across hosts

## Showcase

### Hyprland / Niri

![hyprland](./assets/screenshots/hyprland.png)

### macOS

![macos](./assets/screenshots/mac.png)

## Repository Structure

```text
.
├── assets/                # Generic repo assets such as screenshots
├── hosts/                 # Concrete machine definitions
│   ├── energy/
│   └── work-mac/
├── modules/               # Reusable configuration building blocks
│   ├── configurations/    # Host configuration wrappers (nixosSystem, darwinSystem)
│   ├── profile/           # Personal cross-host profile data and assets
│   ├── nixos/             # NixOS-only modules
│   ├── darwin/            # nix-darwin-only modules
│   ├── home-manager/      # Home Manager modules
│   └── stacks/            # Host-facing composition modules
├── flake.nix              # Flake inputs and top-level imports
├── flake.lock             # Locked input versions for reproducibility
├── Makefile               # Convenience rebuild/update/check commands
└── README.md              # Project documentation
```

## Modules and Configurations

### NixOS Modules (`modules/nixos/`)

- `base/`: Core system building blocks such as boot, networking, locale, users, packages, fonts, and containers.
- `desktop/`: System modules for standalone compositor environments.
- `roles/`: Higher-level system roles such as gaming.

Current desktop modules include:

- `desktop/compositor-common.nix`: Shared system settings for standalone compositors.
- `desktop/hyprland.nix`: Hyprland system integration.
- `desktop/niri.nix`: Niri system integration.

### Darwin Modules (`modules/darwin/`)

- `base/`: Common macOS settings such as defaults, fonts, sudo, keyboard, and user setup.

### Home Manager Modules (`modules/home-manager/`)

- `base/`: Shared packages and user-level defaults.
- `desktop/`: Desktop- or window-manager-specific modules.
- `programs/`: Modules that configure `programs.*`.
- `services/`: Modules that configure `services.*`.
- `scripts/`: Custom helper scripts installed into the user environment.

### Stack Modules (`modules/stacks/`)

Stacks connect system modules and Home Manager modules.

Current stacks:

- `linux-base.nix`: Shared Linux system base plus Home Manager base.
- `darwin-base.nix`: Shared macOS system base plus Home Manager base.
- `hyprland.nix`: Hyprland environment stack.
- `niri.nix`: Niri environment stack.
- `aerospace.nix`: AeroSpace setup for macOS.

## How Composition Works

At a high level:

1. `flake.nix` uses `import-tree` to auto-import all `.nix` files under `modules/`
2. `modules/` exports reusable named modules via `flake.modules.<class>.<name>`
3. `modules/stacks/` combines those modules into host-facing bundles
4. `hosts/default.nix` manually imports the real host definitions under `hosts/`
5. `hosts/` uses `configurations.nixos` or `configurations.darwin` plus stacks to define real machines

That means the flow is roughly:

```text
leaf modules -> branch modules -> stacks -> hosts
```

This is what "dendritic" means in this repo.

## How To Read This Repo

If you are reading this repo for the first time, use this order:

1. `flake.nix`
2. `hosts/default.nix`
3. one real host, for example `hosts/energy/default.nix`
4. a stack used by that host, for example `modules/stacks/hyprland.nix`
5. the underlying modules pulled in by that stack

That gives you the high-level picture before the details.

## How To Use This Repo For Yourself

If you want to fork this repo and adapt it for your own systems, this is the easiest path.

### 1. Fork It

Fork the repository and clone your own copy.

### 2. Replace The Personal Profile

Edit:

- `modules/profile/preferences.nix`

Replace:

- full name
- email
- git key

You can also set avatar, wallpaper, fonts, icon theme, locale and time zone of your choice.

### 3. Remove Machines You Do Not Need

Delete or ignore hosts you do not use.

For example:

- if you only want NixOS, keep `hosts/energy/` as a starting point
- if you only want macOS, keep `hosts/work-mac/` as a starting point

### 4. Create A New Host

For a new NixOS host:

1. Create a new directory under `hosts/`, for example `hosts/laptop/`
2. Add `default.nix`
3. Generate `hardware.nix`: `sudo nixos-generate-config --show-hardware-config > hosts/laptop/hardware.nix`
4. Register the new host in `hosts/default.nix`

Start from `hosts/energy/default.nix` and change:

- hardware imports
- username
- stack choice

Minimal example:

```nix
{ inputs, config, ... }:
let
  inherit (config.flake.modules) nixos;
  username = "your-user";
in
{
  configurations.nixos.laptop.module = {
    imports = [
      ./hardware.nix
      nixos.stackLinuxBase
      nixos.stackHyprland
    ];

    primaryUser = username;
    system.stateVersion = "26.05";

    home-manager.users.${username} = {
      programs.home-manager.enable = true;
      home = {
        inherit username;
        homeDirectory = "/home/${username}";
        stateVersion = "26.05";
      };
    };
  };
}
```

For a new macOS host:

1. Create `hosts/my-mac/default.nix`
2. Start from `hosts/work-mac/default.nix`
3. Change:
   - hostname attr
   - username
   - stack choice
4. Register the new host in `hosts/default.nix`

### 5. Pick The Right Stack

Common choices:

- `nixos.stackLinuxBase`: common Linux system + Home Manager base
- `nixos.stackHyprland`: Hyprland desktop stack
- `nixos.stackNiri`: Niri desktop stack
- `darwin.stackBase`: common macOS base
- `darwin.stackAerospace`: AeroSpace desktop setup for macOS

Rule of thumb:

- hosts import stacks
- stacks import modules
- leaf modules stay focused

### 6. Build It

For NixOS:

```sh
sudo nixos-rebuild switch --flake .#your-nixos-machine-name
```

For nix-darwin:

```sh
darwin-rebuild switch --flake .#your-macos-machine-name
```

Or use the `Makefile`:

```sh
make nixos-rebuild
make darwin-rebuild
make flake-check
```

The `Makefile` defaults to:

```text
.#$(hostname)
```

So it works best when the flake output name matches the machine hostname.

## How To Extend It

### Add a New Program Module

Put it under:

- `modules/home-manager/programs/<name>/default.nix`

Use this for modules that define `programs.*`.

The file will be auto-imported by `import-tree`.

### Add a New Service Module

Put it under:

- `modules/home-manager/services/<name>/default.nix`

Use this for modules that define `services.*`.

### Add a New Standalone Compositor or a Desktop Environment

1. Add a NixOS module under `modules/nixos/desktop/`
2. Add a Home Manager desktop module under `modules/home-manager/desktop/<your_wm_or_de>/`
3. Reuse `nixos.desktopCompositorCommon` and `homeManager.desktopCompositorCommon` where appropriate
4. Add a new stack under `modules/stacks/`
5. Import that stack from a host

## License

This repository is licensed under the MIT License.
