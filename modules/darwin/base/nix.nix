{ ... }:
{
  flake.modules.darwin.base = {
    nixpkgs.config.allowUnfree = true;

    nix = {
      settings.experimental-features = "nix-command flakes";
      optimise.automatic = true;
    };
  };
}
