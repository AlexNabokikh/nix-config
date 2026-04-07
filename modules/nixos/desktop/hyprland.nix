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

      # FIXME: https://github.com/NixOS/nixpkgs/issues/484328
      systemd.services.display-manager.path = [ pkgs.uwsm ];

      environment.systemPackages = with pkgs; [
        grimblast
        hyprpicker
      ];
    };
}
