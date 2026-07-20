{
  inputs,
  lib,
  config,
  ...
}:
{
  options.configurations.darwin = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
          default = { };
          description = "nix-darwin module for this configuration";
        };
      }
    );
    default = { };
    description = "nix-darwin system configurations";
  };

  config.flake = {
    darwinConfigurations = lib.mapAttrs (
      _name: cfg:
      inputs.nix-darwin.lib.darwinSystem {
        modules = [
          inputs.home-manager.darwinModules.home-manager
          config.flake.modules.generic.homeManagerIntegration
          {
            nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";
          }
          cfg.module
        ];
      }
    ) config.configurations.darwin;

    checks = lib.foldlAttrs (
      acc: name: _:
      let
        darwin = config.flake.darwinConfigurations.${name};
        inherit (darwin.config.nixpkgs.hostPlatform) system;
      in
      lib.recursiveUpdate acc {
        ${system}."darwin-${name}" = darwin.config.system.build.toplevel;
      }
    ) { } config.configurations.darwin;
  };
}
