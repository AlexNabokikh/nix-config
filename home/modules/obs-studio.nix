{
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (!pkgs.stdenv.isDarwin) {
    # Install OBS Studio via home-manager module
    programs.obs-studio.enable = true;

    # Enable catppuccin theming for OBS.
    catppuccin.obs.enable = true;
  };
}
