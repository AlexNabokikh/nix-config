{ inputs, ... }:
{
  flake.modules.generic.nixSettings =
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

      nix.settings.experimental-features = "nix-command flakes";
      nix.optimise.automatic = true;
    };

  flake.modules.generic.noctaliaCache = {
    nix.settings.extra-substituters = [ "https://noctalia.cachix.org" ];
    nix.settings.extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };
}
