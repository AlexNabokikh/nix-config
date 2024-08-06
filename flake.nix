{
  description = "NixOS configs for my machines";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS profiles to optimize settings for different hardware
    hardware.url = "github:nixos/nixos-hardware";

    # Global catppuccin theme
    catppuccin.url = "github:catppuccin/nix";

    # NixOS Spicetify
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    catppuccin,
    ...
  } @ inputs: let
    inherit (self) outputs;

    # Define the overlay for pkgs.unstable
    unstable-packages = final: _prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = final.system;
        config.allowUnfree = true;
      };
    };

    # Function for NixOS system configuration
    nixosSystemFor = _: configurationFile:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [configurationFile];
      };

    # Function for Home Manager configuration
    homeManagerFor = user: hostname: {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [unstable-packages];
      };
      extraSpecialArgs = {inherit inputs outputs;};
      modules = [
        ./home/${user}/${hostname}.nix
        catppuccin.homeManagerModules.catppuccin
      ];
    };
  in {
    nixosConfigurations = {
      energy = nixosSystemFor "energy" ./hosts/energy/configuration.nix;
      nabokikh-z13 = nixosSystemFor "nabokikh-z13" ./hosts/nabokikh-z13/configuration.nix;
    };

    homeConfigurations = {
      "nabokikh@energy" = home-manager.lib.homeManagerConfiguration (homeManagerFor "nabokikh" "energy");
      "nabokikh@nabokikh-z13" = home-manager.lib.homeManagerConfiguration (homeManagerFor "nabokikh" "nabokikh-z13");
    };
  };
}
