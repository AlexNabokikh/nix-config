# Adding a New Machine

This guide walks you through adding a new machine to your Nix configuration.

## Prerequisites

- Nix with flakes enabled
- Git access to this repository
- Basic understanding of Nix syntax

## Step-by-Step Guide

### 1. Create User Configuration (if new user)

If you're adding a machine for an existing user, skip to step 2.

Create `users/{username}.nix`:

```nix
{
  avatar = ../files/avatar/face.png;
  email = "user@example.com";
  fullName = "Full Name";
  name = "username";
  sshKeys = [
    "ssh-ed25519 AAAA... user@example.com"
  ];
}
```

### 2. Create Host Configuration

#### For NixOS

Create `hosts/{hostname}/configuration.nix`:

```nix
# Host Configuration: hostname
# Purpose: Brief description
# Platform: NixOS
{
  inputs,
  hostname,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd  # Adjust for your CPU
    inputs.hardware.nixosModules.common-gpu-amd  # Adjust for your GPU
    inputs.hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix
    ../modules/nixos-common.nix
    # Add other modules as needed
  ];

  networking.hostName = hostname;
  system.stateVersion = "24.11";
}
```

Generate hardware configuration:

```bash
sudo nixos-generate-config --show-hardware-config > hosts/{hostname}/hardware-configuration.nix
```

#### For macOS

Create `hosts/{hostname}/configuration.nix`:

```nix
# Host Configuration: hostname
# Purpose: Brief description
# Platform: macOS
{userConfig, hostname, ...}: {
  imports = [
    ../modules/avatar.nix
    ../modules/darwin-common.nix
    ../modules/mac-common.nix
  ];

  # Machine-specific settings
  system.defaults.dock = {
    autohide = true;
    persistent-apps = [
      "/Applications/Safari.app"
      # Add your apps
    ];
  };

  networking.hostName = hostname;
  system.stateVersion = 5;
}
```

### 3. Create Home Manager Configuration

Create `home/{username}/{hostname}.nix`:

```nix
# Home Configuration: username@hostname
# Purpose: User environment for this machine
# Platform: NixOS/macOS
{...}: {
  imports = [
    ../modules/home.nix
    ../modules/common.nix
    # Add platform-specific modules
  ];

  programs.home-manager.enable = true;

  # macOS specific
  home.sessionPath = ["/opt/homebrew/bin/"];

  home.stateVersion = "24.11";
}
```

### 4. Update flake.nix

Add your configurations to `flake.nix`:

```nix
{
  # ... existing code ...

  # Add to users if new user
  users = {
    fs = import ./users/fs.nix;
    newuser = import ./users/newuser.nix;  # Add this
  };

  # Add to appropriate section
  nixosConfigurations = {
    "nixos" = mkNixosConfiguration "nixos" "fs";
    "newhostname" = mkNixosConfiguration "newhostname" "newuser";  # Add this
  };

  # OR for macOS
  darwinConfigurations = {
    "neo" = mkDarwinConfiguration "neo" "fs";
    "newhostname" = mkDarwinConfiguration "newhostname" "newuser";  # Add this
  };

  # Add home configuration
  homeConfigurations = {
    "fs@nixos" = mkHomeConfiguration "x86_64-linux" "fs" "nixos";
    "newuser@newhostname" = mkHomeConfiguration "x86_64-linux" "newuser" "newhostname";  # Add this, adjust system for macOS (e.g., "aarch64-darwin")
  };
}
```

### 5. Stage and Test

```bash
# Stage all new files
git add .

# Verify flake syntax
nix flake check

# Test build without switching
nix build .#nixosConfigurations.newhostname.config.system.build.toplevel  # NixOS
nix build .#darwinConfigurations.newhostname.system  # macOS
```

### 6. Apply Configuration

#### For NixOS

```bash
# First time setup
sudo nixos-rebuild switch --flake .#newhostname

# Reboot
sudo reboot

# Apply home configuration
home-manager switch --flake .#newuser@newhostname
```

#### For macOS

```bash
# Bootstrap nix-darwin (first time only)
make bootstrap-mac

# Apply Darwin configuration
darwin-rebuild switch --flake .#newhostname

# Or use just
just darwin-switch

# Reboot
sudo reboot

# Apply home configuration
home-manager switch --flake .#newuser@newhostname

# Or use just
just home-switch
```

## Common Modules to Import

### System Modules (hosts/modules/)

**NixOS:**
- `nixos-common.nix` - Base NixOS configuration (required)
- `gnome.nix` - GNOME desktop environment
- `hyprland.nix` - Hyprland compositor
- `laptop.nix` - Laptop power management
- `steam.nix` - Gaming setup

**macOS:**
- `darwin-common.nix` - Base macOS configuration (required)
- `mac-common.nix` - Package imports (required)
- `avatar.nix` - User avatar setup
- `parallels.nix` - Parallels Desktop

### Home Modules (home/modules/)

**Essential:**
- `home.nix` - Home directory setup (required)
- `common.nix` - Base home configuration (required)
- `git.nix` - Git configuration
- `zsh.nix` - Shell configuration
- `neovim.nix` - Text editor

**Optional:**
- `tmux.nix` - Terminal multiplexer
- `alacritty.nix` - Terminal emulator
- `lazygit.nix` - Git TUI
- `btop.nix` - System monitor
- `darwin-aerospace.nix` - macOS tiling WM

## Platform-Specific Notes

### NixOS

- Always generate `hardware-configuration.nix`
- Import appropriate hardware modules from nixos-hardware
- Set `system.stateVersion` to your NixOS version
- Use `systemd.user.startServices = "sd-switch";` in home config

### macOS

- Import `darwin-common.nix` for shared settings
- Set `system.stateVersion = 5;` (nix-darwin version)
- Add `/opt/homebrew/bin/` to `home.sessionPath`
- Don't use systemd options in home config

## Troubleshooting

### Build Fails

```bash
# Show detailed error
nix build .#nixosConfigurations.hostname.config.system.build.toplevel --show-trace

# Check flake
nix flake check --show-trace
```

### Module Not Found

Ensure the module path is correct relative to the importing file:
```nix
# From hosts/{hostname}/configuration.nix
imports = [
  ../modules/nixos-common.nix  # Correct
  ./modules/nixos-common.nix   # Wrong
];
```

### Home Manager Fails

```bash
# Check home configuration
home-manager build --flake .#user@hostname

# Show trace
home-manager switch --flake .#user@hostname --show-trace
```

## Best Practices

1. **Always test before committing**: Run `nix flake check`
2. **Use descriptive hostnames**: e.g., `macbook-pro-work`, `desktop-home`
3. **Document your changes**: Add comments explaining machine-specific settings
4. **Keep it modular**: Import shared modules, only override what's different
5. **Version control**: Commit after each successful build

## Example Configurations

See existing configurations for reference:
- NixOS: `hosts/nixos/configuration.nix`
- macOS: `hosts/neo/configuration.nix`
- Home: `home/fs/neo.nix`

## Next Steps

After successfully adding your machine:

1. Customize your configuration
2. Add machine-specific modules
3. Update documentation if you add new patterns
4. Consider contributing improvements back

## Getting Help

- Check [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- Check [nix-darwin Manual](https://daiderd.com/nix-darwin/manual/)
- Check [Home Manager Manual](https://nix-community.github.io/home-manager/)
- Review existing configurations in this repo
