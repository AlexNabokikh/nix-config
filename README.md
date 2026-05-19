# NixOS and nix-darwin Configurations for My Machines

This repository contains my NixOS and nix-darwin configurations, managed through Nix Flakes.

It is designed for:

- NixOS machines
- macOS machines through `nix-darwin`
- user-level configuration through `home-manager`

The repo follows the [dendritic pattern](https://github.com/mightyiam/dendritic).

In practice, that means:

- every `.nix` file under `modules/` is a top-level module of the flake-parts configuration, auto-imported by [`import-tree`](https://github.com/vic/import-tree)
- each file represents a single feature and declares its own named composite `flake.modules.<class>.<feature>`
- a feature that applies to multiple configuration classes lives in **one file at the root of `modules/`** and declares one composite per class it touches (e.g. `fonts.nix` declares both `darwin.fonts` and `homeManager.fonts`)
- a feature that applies to only one class lives in that class's subdirectory: `modules/nixos/`, `modules/darwin/`, or `modules/programs/` (home-manager)
- `modules/base.nix` is the single composition point: it imports every feature composite into `nixos.base`, `darwin.base`, and `homeManager.base`
- hosts compose features by importing the base modules plus any opt-in extras (e.g. `nixos.hyprland`, `nixos.gaming`) — no intermediate layer

The simplest mental model is:

- `modules/hosts/` = real machines
- `modules/*.nix` and `modules/<group>/*.nix` = reusable feature modules
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
├── assets/                       # Repo assets such as screenshots
├── modules/                      # All configuration modules (auto-imported by import-tree)
│   ├── flake-parts.nix           # Enables flake-parts.flakeModules.modules
│   ├── systems.nix               # System list
│   ├── formatter.nix             # `nix fmt` configuration
│   ├── nix-settings.nix          # Shared nix settings (generic / cross-class)
│   │
│   ├── base.nix                  # Wires generic.* into nixos.base, darwin.base, homeManager.base
│   ├── catppuccin.nix            # Catppuccin theming (nixos + homeManager)
│   ├── fonts.nix                 # Fonts (darwin + homeManager)
│   ├── users.nix                 # User accounts (nixos + darwin)
│   │
│   ├── configurations/           # `configurations.nixos` / `configurations.darwin` option machinery
│   ├── profile/                  # Personal identity, options, assets shared across hosts
│   ├── hosts/                    # Concrete machine definitions
│   │   ├── energy/               # Linux box (has adjacent _hardware.nix)
│   │   └── work-mac.nix          # macOS box
│   │
│   ├── nixos/                    # NixOS-only system features
│   │   ├── audio.nix, bluetooth.nix, boot.nix, containers.nix
│   │   ├── gaming.nix, locale.nix, networking.nix, services.nix
│   │
│   ├── darwin/                   # Darwin-only system features
│   │   ├── keyboard.nix          # Key remapping + system-wide keyboard shortcuts
│   │   ├── system-preferences.nix # macOS UX prefs (dock, finder, trackpad, NSGlobalDomain …)
│   │   └── sudo.nix              # TouchID sudo
│   │
│   ├── desktop/                  # Desktop / compositor features (cross-class)
│   │   ├── compositor-common.nix # Shared compositor system + HM bits
│   │   ├── idle.nix              # Idle handling (hypridle: lock, dpms)
│   │   ├── hyprland/             # Hyprland (system + HM in one file, plus adjacent hyprland.conf)
│   │   ├── niri/                 # Niri (system + HM, plus adjacent config.kdl)
│   │   └── aerospace/            # AeroSpace (darwin + HM, plus adjacent aerospace.toml)
│   │
│   └── programs/                 # Home-manager programs (one file per feature)
├── flake.nix                     # Flake inputs and top-level imports
├── flake.lock                    # Locked input versions for reproducibility
├── Makefile                      # Convenience rebuild/update/check commands
└── README.md                     # Project documentation
```

**Reading the tree at a glance:**

- Files **at the root of `modules/`** are either infrastructure (`flake-parts.nix`, `systems.nix`, …) or **cross-class features** that touch more than one class.
- Files inside **`nixos/`**, **`darwin/`**, or **`programs/`** are **class-specific** — they only apply to that one target.
- **`desktop/`** is a cross-class feature group: each desktop feature declares both system and HM bits in one file.

## Modules and Configurations

The module naming convention is `flake.modules.<class>.<feature>`:

- `class` is `nixos`, `darwin`, `homeManager`, or `generic`
- `feature` is the short name matching the file path

Notable composite modules:

- `nixos.base` and `darwin.base` — system base, composed in `base.nix`. Each pulls in the
  `generic.*` modules (profile, primaryUser, primaryUserHome, nixSettings), every
  class-specific feature composite (`nixos.audio`, `nixos.boot`, `darwin.keyboard`, …),
  and wires `home-manager.sharedModules = [ homeManager.base ]` so HM is available on every host.
- `homeManager.base` — bundles every HM feature composite (`homeManager.alacritty`,
  `homeManager.git`, `homeManager.catppuccin`, `homeManager.fonts`, …).
- `nixos.hyprland`, `nixos.niri` — pull in `nixos.compositorCommon` and wire their HM
  counterparts via `home-manager.sharedModules`.
- `darwin.aerospace` — wires `homeManager.aerospace` for the macOS host.

## How Composition Works

1. `flake.nix` uses `import-tree` to auto-import every `.nix` file under `modules/`.
2. Each feature file declares one or more named composites under `flake.modules.<class>.<feature>`
   (e.g. `audio.nix` declares `nixos.audio`, `fonts.nix` declares both `darwin.fonts` and
   `homeManager.fonts`).
3. `modules/base.nix` imports every feature composite into the corresponding `<class>.base`,
   so registering a new feature is a one-line addition there.
4. Hosts under `modules/hosts/` import composite modules directly via
   `imports = [ nixos.base nixos.hyprland nixos.gaming ]`.

That is the entire flow — there is no separate "stacks" layer.

### The `_` Prefix Convention

Files and directories starting with `_` are ignored by `import-tree`. This is used for
non-module helper files that are imported explicitly by their parent module:

- `_hardware.nix` — NixOS hardware configuration (imported by the host's `default.nix`)

## How To Read This Repo

If you are reading this repo for the first time, use this order:

1. `flake.nix`
2. `modules/hosts/energy/default.nix` — a real host, ~10 lines
3. `modules/base.nix` — the cross-class base composition
4. one feature file, e.g. `modules/desktop/hyprland/default.nix` — to see how a single
   file declares both NixOS and home-manager parts of a feature

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
- if you only want macOS, keep `modules/hosts/work-mac.nix` as a starting point

### 4. Create A New Host

For a new NixOS host:

1. Create a new directory under `modules/hosts/`, for example `modules/hosts/laptop/`
2. Add `default.nix`
3. Generate `_hardware.nix`: `sudo nixos-generate-config --show-hardware-config > modules/hosts/laptop/_hardware.nix`

Start from `modules/hosts/energy/default.nix` and change:

- hardware imports
- username
- feature choice (which `nixos.*` modules to import)

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
      nixos.base
      nixos.hyprland
    ];

    primaryUser = "your-user";
    system.stateVersion = "26.05";
  };
}
```

For a new macOS host:

1. Create `modules/hosts/my-mac.nix` (or `modules/hosts/my-mac/default.nix` if you need
   adjacent files)
2. Start from `modules/hosts/work-mac.nix`
3. Change:
   - the configuration attribute name (e.g. `configurations.darwin."my-mac".module`) — this becomes the flake output name and should match the machine's hostname so the `Makefile` defaults work
   - `primaryUser`
   - feature choice

The new host will be auto-imported by `import-tree` — no manual registration needed.

### 5. Pick The Right Modules

Common choices:

- `nixos.base` — common Linux system + Home Manager base
- `nixos.hyprland` — Hyprland desktop (pulls in compositor-common and HM hyprland)
- `nixos.niri` — Niri desktop (same shape as hyprland)
- `nixos.gaming` — Steam, gaming kernel parameters, pipewire tweaks
- `darwin.base` — common macOS base + Home Manager
- `darwin.aerospace` — AeroSpace tiling window manager for macOS

Rule of thumb:

- hosts import composite features (`nixos.base`, `nixos.hyprland`, …)
- leaf modules under `modules/programs/` etc. stay focused on a single feature
- cross-class wiring lives in the feature file itself

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

- `modules/programs/<name>.nix` (or `modules/programs/<name>/default.nix` if you need
  adjacent config files like `lazyvim/` for neovim)

Use this for modules that define `programs.*` on home-manager. Declare it as
`flake.modules.homeManager.<name> = { ... };` and add `homeManager.<name>` to the
`flake.modules.homeManager.base.imports` list in `modules/base.nix`.

The file will be auto-imported by `import-tree`.

### Add a New NixOS or Darwin Feature Module

System-only features live under `modules/nixos/<name>.nix` or `modules/darwin/<name>.nix`.
Declare them as `flake.modules.nixos.<name> = { ... };` (or `darwin.<name>`) and register
them in the matching imports list inside `modules/base.nix`.

Cross-class features that touch more than one class (system + HM, or NixOS + darwin)
live at the root of `modules/` and declare one composite per class — e.g. `fonts.nix`
declares both `darwin.fonts` and `homeManager.fonts`, each registered in their respective
`base.imports`.

### Add a New Service Module

Home-manager `services.*` modules go into whichever feature group they belong to:

- A service tied to the desktop (e.g. idle daemon, notification daemon) — `modules/desktop/<name>.nix`
- A service tied to a specific program — drop it into that program's file under `modules/programs/<name>.nix`

If you accumulate enough orphan HM services that none of those fit, create a
`modules/services/` directory at the top level (it will be picked up automatically
by `import-tree`).

### Add a New Standalone Compositor or Desktop Environment

1. Create `modules/desktop/<name>/default.nix` declaring both
   `flake.modules.nixos.<name>` (system bits) and `flake.modules.homeManager.<name>`
   (user bits).
2. Have the NixOS half `imports = [ nixos.compositorCommon ]` and wire
   `home-manager.sharedModules = [ homeManager.compositorCommon homeManager.<name> ]`
   so hosts only need to import `nixos.<name>` to get the full stack.
3. Import the feature from a host.

## License

This repository is licensed under the MIT License.
