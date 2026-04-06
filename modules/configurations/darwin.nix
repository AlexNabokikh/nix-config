{ inputs, lib, config, ... }:
{
  options.configurations.darwin = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        system = lib.mkOption {
          type = lib.types.str;
          default = "aarch64-darwin";
          description = "System architecture";
        };
        modules = lib.mkOption {
          type = lib.types.listOf lib.types.raw;
          default = [ ];
          description = "nix-darwin modules to include in this configuration";
        };
      };
    });
    default = { };
    description = "nix-darwin system configurations";
  };

  config.flake.darwinConfigurations = lib.mapAttrs (
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
      ] ++ cfg.modules;
    }
  ) config.configurations.darwin;
}
