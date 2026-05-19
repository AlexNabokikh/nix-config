# NixOS & nix-darwin Configurations

A single Nix flake covering my NixOS hosts, macOS hosts (via [nix-darwin](https://github.com/LnL7/nix-darwin)), and user environment (via [Home Manager](https://github.com/nix-community/home-manager)).

The layout follows the [dendritic pattern](https://github.com/mightyiam/dendritic), with files auto-imported by [`import-tree`](https://github.com/vic/import-tree).

## Showcase

### Hyprland / Niri

![linux](./assets/screenshots/linux.png)

### macOS

![macos](./assets/screenshots/mac.png)

## Layout

```text
.
├── flake.nix         # Inputs; imports everything in modules/
├── Makefile          # Common rebuild, update, and check commands
└── modules/
    ├── base.nix      # Composes features into nixos.base, darwin.base, homeManager.base
    ├── profile/      # Identity and shared appearance settings
    ├── hosts/        # One file or folder per machine
    ├── nixos/        # Linux-only system features
    ├── darwin/       # macOS-only system features
    ├── desktop/      # Compositors and DEs (hyprland, niri, aerospace)
    ├── programs/     # Home-Manager program modules (alacritty, git, neovim, tmux, zsh, …)
    └── *.nix         # Cross-class features (fonts, users, catppuccin, …)
```

## Conventions

- Files under `modules/nixos/`, `modules/darwin/`, or `modules/programs/` declare modules of a single class (`nixos.*`, `darwin.*`, `homeManager.*`).
- Files at the root of `modules/`, and files under `modules/desktop/`, declare composites for more than one class. For example, `fonts.nix` declares both `darwin.fonts` and `homeManager.fonts`.
- `modules/base.nix` collects every feature composite into `nixos.base`, `darwin.base`, and `homeManager.base`. New features are registered there.
- Hosts in `modules/hosts/` import `nixos.base` or `darwin.base` together with any opt-in extras such as `nixos.hyprland`, `nixos.gaming`, or `darwin.aerospace`.
- Files and directories prefixed with `_` (for example `_hardware.nix`) are skipped by `import-tree` and imported explicitly where needed.

## How to use this repo for yourself

### 1. Fork and clone

Fork this repository and clone the fork.

### 2. Replace personal settings

[`modules/profile/preferences.nix`](modules/profile/preferences.nix) declares the personal settings shared across all hosts: name, email, GPG key, Catppuccin flavor, icon and cursor theme, fonts, locale, and timezone.

Replace the asset files with your own:

- `modules/profile/avatar`
- `modules/profile/wallpaper.jpg`

The remaining files in `modules/profile/` wire the `primaryUser` option into NixOS, Darwin, and Home Manager.

### 3. Trim or replace hosts

Remove hosts under `modules/hosts/` that do not apply. `energy/` is a NixOS example; `work-mac.nix` is a macOS example.

### 4. Add a host

For NixOS:

```sh
mkdir -p modules/hosts/laptop
sudo nixos-generate-config --show-hardware-config > modules/hosts/laptop/_hardware.nix
```

`modules/hosts/laptop/default.nix`:

```nix
{ config, ... }:
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

> [!IMPORTANT]
> Substitute the placeholders before building:

- `laptop` (in both the directory path and `configurations.nixos.laptop.module`) — the machine's hostname; matches the flake output name used by the `Makefile`
- `your-user` — the login username; must match the user account configured on the system
- the feature list (`nixos.hyprland`, …) — adjust to taste

For macOS:

copy `modules/hosts/work-mac.nix` and substitute the same placeholders. The shape mirrors the NixOS example, with three differences: the attribute key is `configurations.darwin."<hostname>".module`, the base is `darwin.base` (plus macOS-only extras like `darwin.aerospace`), and there is no `_hardware.nix`.

New host files are picked up by `import-tree` without further registration (but don't forget `git add .` new files).

### 5. Build

```sh
make nixos-rebuild     # NixOS
make darwin-rebuild    # macOS
make flake-check       # validate the flake
make bootstrap-mac     # install Nix and nix-darwin on a fresh Mac
```

`make help` lists all targets. The `Makefile` defaults to `.#$(hostname)`, so flake outputs named after the machine's hostname are selected automatically.

## Adding modules

- A new Home-Manager program lives in `modules/programs/<name>.nix` and declares `flake.modules.homeManager.<name>`. Register `homeManager.<name>` in `homeManager.base.imports` inside `modules/base.nix`.
- A new NixOS-only or Darwin-only system feature lives in `modules/nixos/<name>.nix` or `modules/darwin/<name>.nix`, declares `flake.modules.{nixos,darwin}.<name>`, and is registered in the matching `*.base.imports` list.
- A feature spanning more than one class lives at the root of `modules/`, or under `modules/desktop/` for compositor-adjacent features, and declares one composite per class. `fonts.nix` declares both `darwin.fonts` and `homeManager.fonts`, each registered in its own `base.imports`.

## License

MIT — see [LICENSE](LICENSE).
