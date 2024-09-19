{
  description = "NixOS configs for my machines";

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
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    catppuccin,
    ...
  } @ inputs: let
    inherit (self) outputs;

    # Function for NixOS system configuration
    mkNixosConfiguration = hostname: username:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs username hostname;};
        modules = [./hosts/${hostname}/configuration.nix];
      };

    # Function for Home Manager configuration
    mkHomeConfiguration = system: username: hostname:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {inherit system;};
        extraSpecialArgs = {inherit inputs outputs username;};
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

    homeConfigurations = {
      "nabokikh@energy" = mkHomeConfiguration "x86_64-linux" "nabokikh" "energy";
      "nabokikh@nabokikh-z13" = mkHomeConfiguration "x86_64-linux" "nabokikh" "nabokikh-z13";
    };

    overlays = import ./overlays {inherit inputs;};
  };
}
