{
  inputs,
  lib,
  config,
  ...
}:
let
  mkConfigurationsOption =
    kind:
    lib.mkOption {
      type = lib.types.lazyAttrsOf (
        lib.types.submodule {
          options.module = lib.mkOption {
            type = lib.types.deferredModule;
            default = { };
            description = "${kind} module for this configuration";
          };
        }
      );
      default = { };
      description = "${kind} system configurations";
    };

  mkSystems =
    { builder, extraModules }:
    lib.mapAttrs (
      name: cfg:
      builder {
        modules = extraModules ++ [
          { networking.hostName = lib.mkDefault name; }
          cfg.module
        ];
      }
    );

  mkChecks =
    prefix:
    lib.mapAttrsToList (
      name: built: {
        ${built.config.nixpkgs.hostPlatform.system}."${prefix}-${name}" =
          built.config.system.build.toplevel;
      }
    );

  nixosConfigurations = mkSystems {
    builder = inputs.nixpkgs.lib.nixosSystem;
    extraModules = [ inputs.home-manager.nixosModules.home-manager ];
  } config.configurations.nixos;

  darwinConfigurations = mkSystems {
    builder = inputs.nix-darwin.lib.darwinSystem;
    extraModules = [
      inputs.home-manager.darwinModules.home-manager
      { nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin"; }
    ];
  } config.configurations.darwin;
in
{
  options.configurations = {
    nixos = mkConfigurationsOption "NixOS";
    darwin = mkConfigurationsOption "nix-darwin";
  };

  config.flake = {
    inherit nixosConfigurations darwinConfigurations;

    checks = lib.mkMerge (
      mkChecks "nixos" nixosConfigurations ++ mkChecks "darwin" darwinConfigurations
    );
  };
}
