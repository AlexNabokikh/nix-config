# NixOS & nix-darwin Configurations

A single Nix flake covering my NixOS and macOS machines.

## Showcase

### GNOME

![linux](./assets/screenshots/linux.png)

### macOS

![macos](./assets/screenshots/mac.png)

## Layout

```text
.
├── flake.nix          # Inputs, host definitions, checks, and formatter
├── Makefile           # Common rebuild, update, format, and check commands
├── assets/
│   ├── screenshots/
│   └── wallpapers/    # GNOME light/dark PNGs and macOS dynamic HEIC
├── hosts/             # Machine-specific configurations
│   ├── energy/        # NixOS desktop (GNOME + gaming)
│   ├── xps/           # NixOS laptop (GNOME)
│   └── work-mac.nix   # macOS work laptop (AeroSpace)
└── modules/
    ├── common/        # Shared options, preferences, fonts, nix settings, and HM wiring
    ├── nixos/         # NixOS system features (boot, audio, bluetooth, networking, gaming, …)
    ├── darwin/        # macOS system features (preferences, keyboard, users, aerospace)
    ├── desktop/       # GNOME desktop and its integration (gnome, gtk, qt, cursor)
    └── home/          # Home Manager base, Stylix palette, and per-program modules
        └── programs/  # Individual CLI/GUI tool configurations, Neovim, and scripts
```

## Conventions

- `flake.nix` wires each host directly via `nixpkgs.lib.nixosSystem` or `nix-darwin.lib.darwinSystem`, automatically importing `modules/nixos/base.nix` or `modules/darwin/base.nix`.
- `modules/common/` defines typed `user`, `terminalFont`, and `locale` options and sets shared defaults in [`modules/common/preferences.nix`](modules/common/preferences.nix). Home Manager modules access host-level settings through `osConfig`.
- Baseline workstation features are imported by `modules/nixos/base.nix`, `modules/darwin/base.nix`, and `modules/home/base.nix`. Opt-in features (`modules/desktop/gnome.nix`, `modules/nixos/gaming.nix`, `modules/darwin/aerospace.nix`) are imported explicitly by the hosts that use them.
- `modules/home/stylix.nix` defines the shared Base16 color palette; individual `stylix.targets.*` toggles live inside the program modules they theme.

## How to use this repo for yourself

### 1. Fork and clone

Fork this repository and clone the fork.

### 2. Replace personal settings

Edit [`modules/common/preferences.nix`](modules/common/preferences.nix) to set your shared defaults (`user.fullName`, `user.email`, `user.gitKey`, `terminalFont`, and `locale`). Because all options are typed and set with `lib.mkDefault`, typos are caught immediately and any host in `hosts/` can override them.

Replace the wallpaper files with your own:

- `assets/wallpapers/wallpaper-light.png`
- `assets/wallpapers/wallpaper-dark.png`
- `assets/wallpapers/wallpaper-mac.heic`

The PNGs are applied automatically in GNOME; the HEIC contains matching light/dark variants for manual selection in macOS.

### 3. Trim or replace hosts

Update or remove hosts under `hosts/` and their entries in `flake.nix`.

### 4. Add a host

For NixOS:

```sh
mkdir -p hosts/laptop
sudo nixos-generate-config --show-hardware-config > hosts/laptop/hardware.nix
```

`hosts/laptop/default.nix`:

```nix
{
  imports = [
    ./hardware.nix
    ../../modules/desktop/gnome.nix
  ];

  user.name = "your-user";
  system.stateVersion = "26.05";
}
```

Register it under `nixosConfigurations` in `flake.nix`:

```nix
laptop = mkNixos "laptop" ./hosts/laptop;
```

For macOS, copy `hosts/work-mac.nix`, set `user.name` to your macOS login short name, and register the machine's short hostname under `darwinConfigurations` in `flake.nix`.

Remember to `git add` any new files before building.

### 5. Build

```sh
make nixos-rebuild     # NixOS
make darwin-rebuild    # macOS
make fmt               # format the repository
make flake-check       # validate the flake
```

`make help` lists all targets. The `Makefile` defaults to `.#$(hostname -s)`, so flake outputs named after the machine's short hostname are selected automatically.

## Adding modules

- A new Home Manager program lives in `modules/home/programs/<name>.nix` and is imported in `modules/home/base.nix` (or by its parent feature if opt-in).
- A new NixOS or macOS system feature lives in `modules/nixos/<name>.nix` or `modules/darwin/<name>.nix`; import baseline defaults in the matching `base.nix` and opt-in features in the relevant `hosts/` files.

## License

MIT — see [LICENSE](LICENSE).
