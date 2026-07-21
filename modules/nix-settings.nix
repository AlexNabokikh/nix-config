{ inputs, ... }:
{
  flake.modules.generic.nixSettings = {
    nixpkgs.config.allowUnfree = true;

    nix = {
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

      registry.nixpkgs.flake = inputs.nixpkgs;

      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      optimise.automatic = true;
    };
  };
}
