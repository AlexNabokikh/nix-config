{ ... }:
{
  flake.modules.nixos.desktopHyprland =
    { config, pkgs, ... }:
    {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
      };

      # FIXME: https://github.com/NixOS/nixpkgs/issues/484328
      systemd.services.display-manager.path = [ pkgs.uwsm ];

      # FIXME: Hyprland's quirk. Without it, the cursor in XWayland applications is inconsistent.
      environment.sessionVariables = {
        XCURSOR_SIZE = config.profile.appearance.cursorTheme.size;
        XCURSOR_THEME = config.profile.appearance.cursorTheme.name;
      };

      environment.systemPackages = with pkgs; [
        grimblast
        hyprpicker
      ];
    };
}
