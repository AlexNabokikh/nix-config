{ ... }:
{
  flake.modules.nixos.desktopHyprland =
    { pkgs, ... }:
    {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
      };

      services.displayManager.defaultSession = "hyprland-uwsm";

      programs.uwsm = {
        enable = true;
        waylandCompositors.hyprland = {
          prettyName = "Hyprland";
          comment = "Hyprland compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/start-hyprland";
        };
      };

      environment.systemPackages = with pkgs; [
        grimblast
        hyprpicker
      ];
    };
}
