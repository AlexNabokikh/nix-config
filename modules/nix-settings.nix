{
  flake.modules.generic.nixSettings = {
    nixpkgs.config.allowUnfree = true;

    nix = {
      channel.enable = false;

      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      optimise.automatic = true;
    };
  };
}
