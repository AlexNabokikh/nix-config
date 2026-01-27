{ nixosModules, pkgs, ... }:
{
  imports = [
    "${nixosModules}/desktop/wayland-common"
  ];

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # FIXME: https://github.com/NixOS/nixpkgs/issues/484328
  services.displayManager.defaultSession = "hyprland-uwsm";

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/start-hyprland";
      };
    };
  };

  # Hyprland specific packages
  environment.systemPackages = with pkgs; [
    grimblast
    hyprpicker
  ];
}
