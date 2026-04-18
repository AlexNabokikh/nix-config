{
  inputs,
  lib,
  config,
  ...
}:
{
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
          default = { };
          description = "NixOS module for this configuration";
        };
      }
    );
    default = { };
    description = "NixOS system configurations";
  };

  config.flake = {
    nixosConfigurations = lib.mapAttrs (
      name: cfg:
      inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.home-manager.nixosModules.home-manager
          {
            networking.hostName = lib.mkDefault name;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
          cfg.module
        ];
      }
    ) config.configurations.nixos;

    checks = lib.concatMapAttrs (
      name: cfg:
      let
        nixos = config.flake.nixosConfigurations.${name};
        system = nixos.config.nixpkgs.hostPlatform.system;
      in
      {
        ${system} = {
          "nixos-${name}" = nixos.config.system.build.toplevel;
        };
      }
    ) config.configurations.nixos;
  };
}
