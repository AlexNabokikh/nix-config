{
  description = "NixOS and nix-darwin configs for my machines";
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS profiles to optimize settings for different hardware
    hardware.url = "github:nixos/nixos-hardware";

    # Global catppuccin theme
    catppuccin.url = "github:catppuccin/nix";

    # NixOS Spicetify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Darwin (for MacOS machines)
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = {
    self,
    catppuccin,
    darwin,
    home-manager,
    nix-homebrew,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;

    # Define user configurations
    users = {
      nabokikh = {
        avatar = ./files/avatar/face;
        email = "alexander.nabokikh@olx.pl";
        fullName = "Alexander Nabokikh";
        gitKey = "C5810093";
        name = "nabokikh";
      };
    };

    # Function for NixOS system configuration
    mkNixosConfiguration = hostname: username:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs hostname;
          userConfig = users.${username};
        };
        modules = [./hosts/${hostname}/configuration.nix];
      };

    # Function for nix-darwin system configuration
    mkDarwinConfiguration = hostname: username:
      darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs outputs hostname;
          userConfig = users.${username};
        };
        modules = [
          ./hosts/${hostname}/configuration.nix
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
        ];
      };

    # Function for Home Manager configuration
    mkHomeConfiguration = system: username: hostname:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {inherit system;};
        extraSpecialArgs = {
          inherit inputs outputs;
          userConfig = users.${username};
        };
        modules = [
          ./home/${username}/${hostname}.nix
          catppuccin.homeManagerModules.catppuccin
        ];
      };
  in {
    nixosConfigurations = {
      energy = mkNixosConfiguration "energy" "nabokikh";
      nabokikh-z13 = mkNixosConfiguration "nabokikh-z13" "nabokikh";
    };

    darwinConfigurations = {
      "nabokikh-mac" = mkDarwinConfiguration "nabokikh-mac" "nabokikh";
    };

    homeConfigurations = {
      "nabokikh@energy" = mkHomeConfiguration "x86_64-linux" "nabokikh" "energy";
      "nabokikh@nabokikh-mac" = mkHomeConfiguration "aarch64-darwin" "nabokikh" "nabokikh-mac";
      "nabokikh@nabokikh-z13" = mkHomeConfiguration "x86_64-linux" "nabokikh" "nabokikh-z13";
    };

    overlays = import ./overlays {inherit inputs;};
  };
}
