{
  description = "NixOS and nix-darwin configs for my machines";
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS profiles to optimize settings for different hardware
    hardware.url = "github:nixos/nixos-hardware";

    # Global catppuccin theme
    catppuccin.url = "github:catppuccin/nix";

    # Declarative flatpak manager
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0";

    # Declarative kde plasma manager
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Nix Darwin (for MacOS machines)
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    catppuccin,
    darwin,
    home-manager,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;

    # Define user configurations
    users = {
      "alexander.nabokikh" = {
        avatar = ./files/avatar/face;
        email = "alexander.nabokikh@olx.pl";
        fullName = "Alexander Nabokikh";
        gitKey = "C5810093";
        name = "alexander.nabokikh";
      };
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
          nixosModules = "${self}/modules/nixos";
        };
        modules = [./hosts/${hostname}];
      };

    # Function for nix-darwin system configuration
    mkDarwinConfiguration = hostname: username:
      darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs outputs hostname;
          userConfig = users.${username};
          darwinModules = "${self}/modules/darwin";
        };
        modules = [
          ./hosts/${hostname}
          home-manager.darwinModules.home-manager
        ];
      };

    # Function for Home Manager configuration
    mkHomeConfiguration = system: username: hostname:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {inherit system;};
        extraSpecialArgs = {
          inherit inputs outputs;
          userConfig = users.${username};
          nhModules = "${self}/modules/home-manager";
        };
        modules = [
          ./home/${username}/${hostname}
          catppuccin.homeModules.catppuccin
        ];
      };
  in {
    nixosConfigurations = {
      energy = mkNixosConfiguration "energy" "nabokikh";
    };

    darwinConfigurations = {
      "PL-OLX-KCGXHGK3PY" = mkDarwinConfiguration "PL-OLX-KCGXHGK3PY" "alexander.nabokikh";
    };

    homeConfigurations = {
      "alexander.nabokikh@PL-OLX-KCGXHGK3PY" = mkHomeConfiguration "aarch64-darwin" "alexander.nabokikh" "PL-OLX-KCGXHGK3PY";
      "nabokikh@energy" = mkHomeConfiguration "x86_64-linux" "nabokikh" "energy";
    };

    overlays = import ./overlays {inherit inputs;};
  };
}
