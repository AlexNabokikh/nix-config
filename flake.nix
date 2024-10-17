{
  description = "NixOS and nix-darwin configs for my machines";
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
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
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    catppuccin,
    darwin,
    ...
  } @ inputs: let
    inherit (self) outputs;

    # Define user configurations
    users = {
      nabokikh = {
        email = "alexander.nabokikh@olx.pl";
        fullName = "Alexander Nabokikh";
        gitKey = "C5810093";
        name = "nabokikh";
      };
      alexander.nabokikh = {
        email = "alexander.nabokikh@olx.pl";
        fullName = "Alexander Nabokikh";
        gitKey = "C5810093";
        name = "alexander.nabokikh";
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
          {
            home = {
              inherit username;
              homeDirectory =
                if system == "aarch64-darwin"
                then "/Users/${username}"
                else "/home/${username}";
            };
          }
        ];
      };
  in {
    nixosConfigurations = {
      energy = mkNixosConfiguration "energy" "nabokikh";
      nabokikh-z13 = mkNixosConfiguration "nabokikh-z13" "nabokikh";
    };

    darwinConfigurations = {
      "PL-OLX-H7236KQ94R" = mkDarwinConfiguration "PL-OLX-H7236KQ94R" "alexander.nabokikh";
    };

    homeConfigurations = {
      "nabokikh@energy" = mkHomeConfiguration "x86_64-linux" "nabokikh" "energy";
      "nabokikh@nabokikh-z13" = mkHomeConfiguration "x86_64-linux" "nabokikh" "nabokikh-z13";
      "alexander.nabokikh@PL-OLX-H7236KQ94R" = mkHomeConfiguration "aarch64-darwin" "alexander.nabokikh" "PL-OLX-H7236KQ94R";
    };

    overlays = import ./overlays {inherit inputs;};
  };
}
