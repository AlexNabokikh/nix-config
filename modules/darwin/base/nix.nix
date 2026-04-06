{ ... }:
{
  flake.modules.darwin.nix = {
    nixpkgs.config.allowUnfree = true;

    nix = {
      settings.experimental-features = "nix-command flakes";
      optimise.automatic = true;
    };
  };
}
