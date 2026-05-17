{
  flake.modules.nixos.desktopHyprland =
    { config, ... }:
    {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
      };

      # Hyprland's quirk under uwsm. Without it, the cursor in XWayland applications is inconsistent.
      # https://wiki.hypr.land/Configuring/Environment-variables/
      environment.sessionVariables = {
        XCURSOR_SIZE = config.profile.appearance.cursorTheme.size;
        XCURSOR_THEME = config.profile.appearance.cursorTheme.name;
      };
    };
}
