{ inputs, ... }:
{
  flake.modules.generic.nixSettings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      nixpkgs.config.allowUnfree = true;

      nix = {
        registry = lib.mapAttrs (_: flake: { inherit flake; }) (
          lib.filterAttrs (_: lib.isType "flake") inputs
        );

        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          extra-substituters = [ "https://noctalia.cachix.org" ];
          extra-trusted-public-keys = [
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          ];
        };

        optimise.automatic = true;

        nixPath = lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) [ "/etc/nix/path" ];
      };

      environment.etc = lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) (
        lib.mapAttrs' (name: value: {
          name = "nix/path/${name}";
          value.source = value.flake;
        }) config.nix.registry
      );
    };
}
