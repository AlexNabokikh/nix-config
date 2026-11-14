{
  description = "NixOS and nix-darwin configs for my machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      forAllSystems = f: lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});

      mkNixos =
        hostName: hostModule:
        lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./modules/nixos/base.nix
            { networking.hostName = lib.mkDefault hostName; }
            hostModule
          ];
        };

      mkDarwin =
        hostName: hostModule:
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./modules/darwin/base.nix
            { networking.hostName = lib.mkDefault hostName; }
            hostModule
          ];
        };

      nixosConfigurations = {
        energy = mkNixos "energy" ./hosts/energy;
        xps = mkNixos "xps" ./hosts/xps;
      };

      darwinConfigurations = {
        "PL-OLX-KCGXHGK3PY" = mkDarwin "PL-OLX-KCGXHGK3PY" ./hosts/work-mac.nix;
      };
    in
    {
      inherit nixosConfigurations darwinConfigurations;

      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);

      checks = {
        x86_64-linux = lib.mapAttrs' (
          name: host: lib.nameValuePair "nixos-${name}" host.config.system.build.toplevel
        ) nixosConfigurations;
        aarch64-darwin = lib.mapAttrs' (
          name: host: lib.nameValuePair "darwin-${name}" host.config.system.build.toplevel
        ) darwinConfigurations;
      };
    };
}
