{ inputs, lib, config, ... }:
{
  options.configurations.darwin = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.submodule {
      options = {
        system = lib.mkOption {
          type = lib.types.str;
          default = "aarch64-darwin";
          description = "System architecture";
        };
        module = lib.mkOption {
          type = lib.types.deferredModule;
          default = { };
          description = "nix-darwin module for this configuration";
        };
      };
    });
    default = { };
    description = "nix-darwin system configurations";
  };

  config.flake = {
    darwinConfigurations = lib.mapAttrs (
      _name: cfg:
      inputs.darwin.lib.darwinSystem {
        inherit (cfg) system;
        modules = [
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
          cfg.module
        ];
      }
    ) config.configurations.darwin;

    checks = lib.concatMapAttrs (
      name: cfg:
      let
        darwin = config.flake.darwinConfigurations.${name};
      in
      {
        ${cfg.system} = {
          "darwin-${name}" = darwin.config.system.build.toplevel;
        };
      }
    ) config.configurations.darwin;
  };
}
