{ inputs, lib, config, ... }:
{
  options.configurations.nixos = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options.modules = lib.mkOption {
        type = lib.types.listOf lib.types.raw;
        default = [ ];
        description = "NixOS modules to include in this configuration";
      };
    });
    default = { };
    description = "NixOS system configurations";
  };

  config.flake.nixosConfigurations = lib.mapAttrs (
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
      ] ++ cfg.modules;
    }
  ) config.configurations.nixos;
}
