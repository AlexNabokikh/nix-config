# NixOS Configurations for My Machines

This repository contains NixOS configurations for my machines, managed through [Nix Flakes](https://nixos.wiki/wiki/Flakes).

It is structured to easily accommodate multiple machines and user configurations, leveraging [nixpkgs](https://github.com/NixOS/nixpkgs), [home-manager](https://github.com/nix-community/home-manager), and various other community contributions for a seamless NixOS experience.

## Showcase

### Hyprland

![hyprland](./files/screenshots/2024-05-06.png)

### Gnome

![gnome](./files/screenshots/2024-07-02.png)

## Structure

- `flake.nix`: The flake itself, defining inputs (such as nixpkgs, home-manager, and hardware-specific optimizations) and outputs for NixOS and Home Manager configurations.
- `hosts/`: NixOS configurations for each machine, including system-specific settings.
- `home/`: Home Manager configurations for user-specific settings and applications.
- `files/`: Miscellaneous configuration files and scripts used across various applications and services.
- `flake.lock`: Lock file ensuring reproducible builds by pinning input versions.
- `overlays/`: Custom Nix overlays for package modifications or additions.

### Key Inputs

- **nixpkgs**: Points to the `nixos-24.05` channel, providing stable NixOS packages.
- **nixpkgs-unstable**: Points to the `nixos-unstable` channel for access to the latest packages.
- **home-manager**: Manages user-specific configurations, following the `nixpkgs` input (release-24.05).
- **hardware**: Optimizes settings for different hardware configurations.
- **catppuccin**: Provides global Catppuccin theme integration.
- **spicetify-nix**: Enhances Spotify client customization.

## Usage

### Adding a New Machine with a New User

To add a new machine with a new user to your NixOS configuration, follow these steps:

1. **Update `flake.nix`**:

   a. Add the new user to the `users` attribute set:

   ```nix
   users = {
     # Existing users...
     newuser = {
       email = "newuser@example.com";
       fullName = "New User";
       gitKey = "YOUR_GIT_KEY";
       name = "newuser";
     };
   };
   ```

   b. Add the new machine to the `nixosConfigurations`:

   ```nix
   nixosConfigurations = {
     # Existing configurations...
     newmachine = mkNixosConfiguration "newmachine" "newuser";
   };
   ```

   c. Add the new home configuration:

   ```nix
   homeConfigurations = {
     # Existing configurations...
     "newuser@newmachine" = mkHomeConfiguration "x86_64-linux" "newuser" "newmachine";
   };
   ```

2. **Create NixOS Configuration**:

   a. Create a new directory under `hosts/` for your machine:

   ```sh
   mkdir -p hosts/newmachine
   ```

   b. Create `configuration.nix` in this directory:

   ```sh
   touch hosts/newmachine/configuration.nix
   ```

   c. Add the basic configuration to `configuration.nix`:

   ```nix
   { config, pkgs, ... }:

   {
     imports = [
       ./hardware-configuration.nix
       ../modules/common.nix
       # Add other relevant modules
     ];

     # Add machine-specific configurations here
   }
   ```

   d. Generate `hardware-configuration.nix`:

   ```sh
   sudo nixos-generate-config --show-hardware-config > hosts/newmachine/hardware-configuration.nix
   ```

3. **Create Home Manager Configuration**:

   a. Create a new file for the user's home configuration:

   ```sh
   mkdir -p home/newuser
   touch home/newuser/newmachine.nix
   ```

   b. Add basic home configuration:

   ```nix
   { config, pkgs, ... }:

   {
     imports = [
       ../modules/common.nix
       # Add other relevant modules
     ];

     # Add user-specific configurations here
   }
   ```

4. **Building and Applying Configurations**:

   a. Do not forget to check-in new files in git by running `git add .`

   b. Build and switch to the new NixOS configuration:

   ```sh
   sudo nixos-rebuild switch --flake .#newmachine
   ```

   c. Build and switch to the new Home Manager configuration:

   ```sh
   home-manager switch --flake .#newuser@newmachine
   ```

## Updating Flakes

To update all flake inputs to their latest versions:

```sh
nix flake update
```

## Custom Modules and Configurations

This setup includes various custom modules and configurations:

- **Desktop Environments**: Supports both Hyprland and GNOME.
- **Development Tools**: Includes configurations for Neovim, Git, Go, and more.
- **System Tools**: Configures utilities like Alacritty, Atuin, Bottom, and FZF.
- **Audio**: Includes EasyEffects for audio enhancement.
- **Gaming**: Supports Steam and Lutris for gaming on NixOS.
- **AI/ML**: Includes Ollama for local AI model running.

## Contributing

Contributions are welcome! If you have improvements or suggestions, please open an issue or submit a pull request.

## License

This repository is licensed under MIT License. Feel free to use, modify, and distribute according to the license terms.
