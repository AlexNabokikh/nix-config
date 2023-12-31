{
  description = "NixOS configs for my machines";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS profiles to optimize settings for different hardware
    hardware.url = "github:nixos/nixos-hardware";

    # NixOS Spicetify
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;

    # Function for NixOS system configuration
    nixosSystemFor = hostname: configurationFile:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [configurationFile];
      };

    # Function for Home Manager configuration
    homeManagerFor = user: hostname: {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {inherit inputs outputs;};
      modules = [./home/${user}/home.nix];
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
