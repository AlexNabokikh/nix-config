{ inputs, ... }:
{
  flake.modules.generic.nixSettings =
    {
      lib,
      pkgs,
      ...
    }:
    {
      nixpkgs.config.allowUnfree = true;

      nix = {
        nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

        registry.nixpkgs.flake = inputs.nixpkgs;

        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
        }
        // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
          extra-substituters = [ "https://noctalia.cachix.org" ];
          extra-trusted-public-keys = [
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          ];
        };

        optimise.automatic = true;
      };
    };
}
