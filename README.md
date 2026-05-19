# NixOS and nix-darwin Configurations for My Machines

This repository contains my NixOS and nix-darwin configurations, managed through Nix Flakes.

It is designed for:

- NixOS machines
- macOS machines through `nix-darwin`
- user-level configuration through `home-manager`

The repo follows the [dendritic pattern](https://github.com/mightyiam/dendritic).

In practice, that means:

- small modules do one thing
- branch modules group related settings
- stacks combine reusable modules into host-level choices
- hosts stay short and easy to read

The simplest mental model is:

- `modules/hosts/` = real machines
- `modules/` = reusable building blocks
- `modules/stacks/` = convenient bundles of those building blocks
- `modules/profile/` = personal settings shared across hosts

## Table of Contents

- [Showcase](#showcase)
- [Repository Structure](#repository-structure)
- [Modules and Configurations](#modules-and-configurations)
- [How Composition Works](#how-composition-works)
- [How To Read This Repo](#how-to-read-this-repo)
- [How To Use This Repo For Yourself](#how-to-use-this-repo-for-yourself)
- [How To Extend It](#how-to-extend-it)

## Showcase

### Hyprland / Niri

![hyprland](./assets/screenshots/hyprland.png)

### macOS

![macos](./assets/screenshots/mac.png)

## Repository Structure

```text
.
├── assets/                # Generic repo assets such as screenshots
├── modules/               # All configuration modules (auto-imported by import-tree)
│   ├── configurations/    # Host configuration wrappers (nixosSystem, darwinSystem)
│   ├── hosts/             # Concrete machine definitions
│   │   ├── energy/
│   │   └── work-mac/
│   ├── profile/           # Personal cross-host profile data and assets
│   ├── nixos/             # NixOS-only modules
│   ├── darwin/            # nix-darwin-only modules
│   ├── home-manager/      # Home Manager modules
│   ├── theme/             # Cross-cutting theme integrations
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
4. `modules/hosts/` uses `configurations.nixos` or `configurations.darwin` plus stacks to define real machines

That means the flow is roughly:

```text
leaf modules -> branch modules -> stacks -> hosts
```

This is what "dendritic" means in this repo.

### The `_` Prefix Convention

Files and directories starting with `_` are ignored by `import-tree`. This convention is used for non-module helper files that are imported explicitly by their parent module, such as:

- `_hardware.nix` — NixOS hardware configuration (imported by the host's `default.nix`)
- `_colors.nix`, `_plugins.nix` — helper data files (imported by their parent module)

### Composition example based on Energy host

![energy](./assets/composition.png)

## How To Read This Repo

If you are reading this repo for the first time, use this order:

1. `flake.nix`
2. one real host, for example `modules/hosts/energy/default.nix`
3. a stack used by that host, for example `modules/stacks/hyprland.nix`
4. the underlying modules pulled in by that stack

That gives you the high-level picture before the details.

## How To Use This Repo For Yourself

If you want to fork this repo and adapt it for your own systems, this is the easiest path.

### 1. Fork It

Fork the repository and clone your own copy.

### 2. Replace The Personal Profile

Edit `modules/profile/preferences.nix` and replace:

- full name
- email
- git key

You can also adjust fonts, icon theme, cursor theme, Catppuccin flavor/accent, locale and time zone in the same file.

Replace the asset files in `modules/profile/` to match your identity:

- `modules/profile/avatar` — user avatar image
- `modules/profile/wallpaper.jpg` — desktop wallpaper

The other files in `modules/profile/` (`primary-user.nix`, `primary-user-home.nix`) are infrastructure — they define the `primaryUser` option and wire Home Manager from it. You generally do not need to edit them.

### 3. Remove Machines You Do Not Need

Delete or ignore hosts you do not use.

For example:

- if you only want NixOS, keep `modules/hosts/energy/` as a starting point
- if you only want macOS, keep `modules/hosts/work-mac/` as a starting point

### 4. Create A New Host

For a new NixOS host:

1. Create a new directory under `modules/hosts/`, for example `modules/hosts/laptop/`
2. Add `default.nix`
3. Generate `_hardware.nix`: `sudo nixos-generate-config --show-hardware-config > modules/hosts/laptop/_hardware.nix`

Start from `modules/hosts/energy/default.nix` and change:

- hardware imports
- username
- stack choice

The new host will be auto-imported by `import-tree` — no manual registration needed.

Minimal example:

```nix
{ inputs, config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.laptop.module = {
    imports = [
      ./_hardware.nix
      nixos.stackLinuxBase
      nixos.stackHyprland
    ];

    primaryUser = "your-user";
    system.stateVersion = "26.05";
  };
}
```

For a new macOS host:

1. Create `modules/hosts/my-mac/default.nix`
2. Start from `modules/hosts/work-mac/default.nix`
3. Change:
   - the configuration attribute name (e.g. `configurations.darwin."my-mac".module`) — this becomes the flake output name and should match the machine's hostname so the `Makefile` defaults work
   - `primaryUser`
   - stack choice

The new host will be auto-imported by `import-tree` — no manual registration needed.

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

Run `make help` for the full target list.

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
