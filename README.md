# NixOS and nix-darwin Configurations for My Machines

This repository contains NixOS and nix-darwin configurations for my machines, managed through [Nix Flakes](https://nixos.wiki/wiki/Flakes).

It is structured to easily accommodate multiple machines and user configurations, leveraging [nixpkgs](https://github.com/NixOS/nixpkgs), [home-manager](https://github.com/nix-community/home-manager), [nix-darwin](https://github.com/LnL7/nix-darwin), and various other community contributions for a seamless experience across NixOS and macOS.

## Showcase

### Hyprland

![hyprland](./files/screenshots/hyprland.png)

### KDE

![kde](./files/screenshots/kde.png)

### macOS

![macos](./files/screenshots/mac.png)

## Structure

- `flake.nix`: The flake itself, defining inputs and outputs for NixOS, nix-darwin, and Home Manager configurations.
- `hosts/`: NixOS and nix-darwin configurations for each machine
- `home/`: Home Manager configurations for each machine
- `files/`: Miscellaneous configuration files and scripts used across various applications and services
- `modules/`: Reusable platform-specific modules
  - `nixos/`: NixOS-specific modules
  - `darwin/`: macOS-specific modules
  - `home-manager/`: User-space configuration modules
- `flake.lock`: Lock file ensuring reproducible builds by pinning input versions
- `overlays/`: Custom Nix overlays for package modifications or additions

### Key Inputs

- **nixpkgs**: Points to the `nixos-unstable` channel for access to the latest packages
- **nixpkgs-stable**: Points to the `nixos-25.05` channel, providing stable NixOS packages
- **home-manager**: Manages user-specific configurations, following the `nixpkgs` input (release-25.05)
- **hardware**: Optimizes settings for different hardware configurations
- **catppuccin**: Provides global Catppuccin theme integration
- **nix-flatpak**: Provides declarative way to manage flatpaks
- **darwin**: Enables nix-darwin for macOS system configuration

## Usage

### Adding a New Machine with a New User

To add a new machine with a new user to your NixOS or nix-darwin configuration, follow these steps:

1. **Update `flake.nix`**:

   a. Add the new user to the `users` attribute set:

   ```nix
   users = {
     # Existing users...
     newuser = {
       avatar = ./files/avatar/face;
       email = "newuser@example.com";
       fullName = "New User";
       gitKey = "YOUR_GIT_KEY";
       name = "newuser";
     };
   };
   ```

   b. Add the new machine to the appropriate configuration set:

   For NixOS:

   ```nix
   nixosConfigurations = {
     # Existing configurations...
     newmachine = mkNixosConfiguration "newmachine" "newuser";
   };
   ```

   For nix-darwin:

   ```nix
   darwinConfigurations = {
     # Existing configurations...
     newmachine = mkDarwinConfiguration "newmachine" "newuser";
   };
   ```

   c. Add the new home configuration:

   ```nix
   homeConfigurations = {
     # Existing configurations...
     "newuser@newmachine" = mkHomeConfiguration "x86_64-linux" "newuser" "newmachine";
   };
   ```

2. **Create System Configuration**:

   a. Create a new directory under `hosts/` for your machine:

   ```sh
   mkdir -p hosts/newmachine
   ```

   b. Create `default.nix` in this directory:

   ```sh
   touch hosts/newmachine/default.nix
   ```

   c. Add the basic configuration to `default.nix`:

   For NixOS:

   ```nix
   { inputs, hostname, nixosModules, ... }:
   {
     imports = [
       inputs.hardware.nixosModules.common-cpu-amd
       ./hardware-configuration.nix
       "${nixosModules}/common"
       "${nixosModules}/programs/hyprland"
     ];

     networking.hostName = hostname;
   }
   ```

   For nix-darwin:

   ```nix
   { config, pkgs, ... }:
   {
     # Add machine-specific configurations here
   }
   ```

   d. For NixOS, generate `hardware-configuration.nix`:

   ```sh
   sudo nixos-generate-config --show-hardware-config > hosts/newmachine/hardware-configuration.nix
   ```

3. **Create Home Manager Configuration**:

   a. Create a new directory for the user's host-specific configuration:

   ```sh
   mkdir -p home/newuser/newmachine
   touch home/newuser/newmachine/default.nix
   ```

   b. Add basic home configuration:

   ```nix
   { nhModules, ... }:
   {
     imports = [
       "${nhModules}/common"
       "${nhModules}/programs/neovim"
       "${nhModules}/services/waybar"
     ];
   }
   ```

4. **Building and Applying Configurations**:

   a. Commit new files to git:

   ```sh
   git add .
   ```

   b. Build and switch to the new system configuration:

   For NixOS:

   ```sh
   sudo nixos-rebuild switch --flake .#newmachine
   ```

   For nix-darwin (requires Nix and nix-darwin installation first):

   ```sh
   darwin-rebuild switch --flake .#newmachine
   ```

   c. Build and switch to the new Home Manager configuration:

> [!IMPORTANT]
> On fresh systems, bootstrap Home Manager first:

```sh
nix-shell -p home-manager
home-manager switch --flake .#newuser@newmachine
```

After this initial setup, you can rebuild configurations separately and home-manager will be available without additional steps

## Updating Flakes

To update all flake inputs to their latest versions:

```sh
nix flake update
```

## Modules and Configurations

### System Modules (in `modules/nixos/`)

- **`common/`**: Common system space configurations
- **`hyprland`**: Hyprland window manager
- **`kde`**: KDE Desktop environment
- **`steam`**: Steam gaming platform
- **`tlp`**: Laptop power management

### Home Manager Modules (in `modules/home-manager/`)

- **`common/`**: Common user space configurations
- **`aerospace` (Darwin):** Tiling window manager for macOS with custom keybindings and workspace rules.
- **`alacritty`:** GPU-accelerated terminal emulator, configured for tmux integration and platform-specific font sizes/decorations.
- **`atuin`:** Enhanced shell history with cloud sync capabilities.
- **`bat`:** Cat clone with syntax highlighting and Git integration.
- **`brave`:** Web browser with XDG MIME type associations (Linux).
- **`btop`:** Resource monitor with Vim keys.
- **`cliphist` (Linux/Hyprland):** Clipboard manager.
- **`easyeffects` (Linux):** Audio effects processor with a custom "mic" preset for input.
- **`fastfetch`:** Customized system information tool.
- **`fzf`:** Command-line fuzzy finder. **Note:** The `ctrl-y` clipboard binding needs to be conditional (`pbcopy` for macOS, `wl-copy` for Wayland/Linux) for cross-platform compatibility.
- **`git`:** Version control system, configured with user details, GPG signing, and `delta` for diffs.
- **`go`:** Golang development environment setup.
- **`gpg`:** GnuPG settings and GPG agent configuration (with `pinentry-gnome3` on Linux).
- **`gtk`:** GTK3/4 theming (Tela-circle icons, Yaru cursor, Roboto font) and Catppuccin theme.
- **`hyprland`**: Hyprland window manager setup
- **`kde`**: KDE Desktop environment user level configuration
- **`k9s`:** Kubernetes CLI To Manage Your Clusters In Style, with custom hotkeys.
- **`kanshi` (Linux/Hyprland):** Dynamic display output configuration based on connected monitors.
- **`krew`:** Kubectl plugin manager with a predefined list of plugins.
- **`lazygit`:** Terminal UI for Git.
- **`neovim`:** Highly customized Neovim setup based on LazyVim, with numerous LSP and development tool integrations.
- **`obs-studio` (Linux):** Streaming and screen recording software.
- **`qt` (Linux):** Qt theming using Kvantum and Catppuccin.
- **`saml2aws`:** For AWS authentication via SAML.
- **`scripts/`**: Collection of development utilities
- **`starship`:** Cross-shell prompt with custom configuration.
- **`swaync` (Linux/Hyprland):** Notification daemon.
- **`telegram`:** Desktop client for Telegram.
- **`tmux`:** Terminal multiplexer with custom keybindings and Catppuccin theme.
- **`ulauncher` (Linux):** Application launcher with custom shortcuts for Brave search, system actions (lock, suspend, shutdown, reboot), and launching work applications.
- **`wallpaper`:** Defines the default wallpaper path.
- **`waybar` (Linux/Hyprland):** Highly customized Wayland status bar with modules for workspaces, system stats, clock, tray, etc.
- **`xdg`:** Manages XDG user directories and default MIME type associations for applications like Totem, Loupe, and TextEditor.
- **`zsh`:** Zsh shell with extensive aliases (git, kubectl), completions, and custom keybindings.

## Contributing

Contributions are welcome! If you have improvements or suggestions, please open an issue or submit a pull request.

## License

This repository is licensed under MIT License. Feel free to use, modify, and distribute according to the license terms.
