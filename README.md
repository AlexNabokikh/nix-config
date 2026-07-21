# NixOS & nix-darwin Configurations

A single Nix flake covering my NixOS hosts and macOS hosts.

The repo follows the [dendritic pattern](https://github.com/mightyiam/dendritic).

## Showcase

### Niri

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
    ├── configurations/ # Instantiates hosts and generates system checks
    ├── flake-parts.nix # Flake-parts module integrations
    ├── systems.nix   # Systems supported by per-system outputs
    ├── formatter.nix # Repository-wide Nix formatter
    ├── profile/      # Identity and shared appearance settings
    ├── hosts/        # Hosts definitions
    ├── nixos/        # NixOS-only system features
    ├── darwin/       # macOS-only system features
    ├── desktop/      # Shared compositor config (gtk, qt, cursor, dconf, …)
    │   └── wm/       # Window manager choices (niri, aerospace)
    ├── programs/     # Home-Manager program modules (alacritty, git, neovim, tmux, zsh, …)
    └── *.nix         # Cross-class features (fonts, users, catppuccin, …)
```

## Conventions

- Files under `modules/nixos/`, `modules/darwin/`, or `modules/programs/` typically declare modules of a single class (`nixos.*`, `darwin.*`, `homeManager.*`). Vertical program features such as Zsh, Podman, Brave, and Mos may declare modules for more than one class.
- Files at the root of `modules/`, and files under `modules/desktop/`, may span more than one class. For example, `fonts.nix` declares both `darwin.fonts` and `homeManager.fonts`, and `users.nix` declares both `nixos.users` and `darwin.users`. Single-class modules may also live there (e.g. `catppuccin.nix`, `desktop/gtk.nix`).
- `modules/base.nix` collects default workstation features into `nixos.base`, `darwin.base`, and `homeManager.base`. Opt-in features are composed by their owning host or parent feature instead.
- Hosts in `modules/hosts/` import `nixos.base` or `darwin.base` together with any opt-in extras such as `nixos.niri`, `nixos.gaming`, or `darwin.aerospace`.
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

Remove hosts under `modules/hosts/` that do not apply. `energy/` and `xps/` are NixOS examples; `work-mac.nix` is a macOS example.

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
      nixos.niri
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
- the feature list (`nixos.niri`, …) — adjust to taste

For macOS:

copy `modules/hosts/work-mac.nix` and substitute the same placeholders. The shape mirrors the NixOS example, with three differences: the attribute key is `configurations.darwin."<hostname>".module`, the base is `darwin.base` (plus macOS-only extras like `darwin.aerospace`), and there is no `_hardware.nix`.

New host files are picked up by `import-tree` without further registration (but don't forget `git add .` new files).

### 5. Build

```sh
make nixos-rebuild     # NixOS
make darwin-rebuild    # macOS
make fmt               # format the repository
make flake-check       # validate the flake
```

`make help` lists all targets. The `Makefile` defaults to `.#$(hostname)`, so flake outputs named after the machine's hostname are selected automatically. Complete NixOS and Darwin system checks must be built on their matching platforms.

## Adding modules

- A new Home-Manager program lives in `modules/programs/<name>.nix` and declares `flake.modules.homeManager.<name>`. Register default workstation programs in `homeManager.base`; import opt-in programs from their owning feature.
- A new NixOS-only or Darwin-only system feature lives in `modules/nixos/<name>.nix` or `modules/darwin/<name>.nix` and declares `flake.modules.{nixos,darwin}.<name>`. Register defaults in the matching base and import opt-in features from hosts.
- A feature spanning more than one class may live beside its primary concern or under `modules/desktop/` for compositor-adjacent features. Register each default class module independently; parent features may compose subordinate modules directly.

## License

MIT — see [LICENSE](LICENSE).
