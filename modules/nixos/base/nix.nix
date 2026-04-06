{ inputs, ... }:
{
  flake.modules.nixos.base =
    {
      config,
      lib,
      ...
    }:
    {
      nixpkgs.config.allowUnfree = true;

      nix.registry = lib.mapAttrs (_: flake: { inherit flake; }) (
        lib.filterAttrs (_: lib.isType "flake") inputs
      );

      nix.nixPath = [ "/etc/nix/path" ];
      environment.etc = lib.mapAttrs' (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      }) config.nix.registry;

      nix.settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
      };
    };
}
