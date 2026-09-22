{ inputs, ... }:
{
  flake.modules.nixos.noctaliaGreeter =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (config.profile.appearance) catppuccin cursorTheme;
      inherit (config.profile.appearance.fonts) ui;

      palette = lib.importJSON "${inputs.catppuccin-palette}/palette.json";
      color = name: palette.${catppuccin.flavor}.colors.${name}.hex;
    in
    {
      fonts.packages = [ ui.package ];

      services.displayManager.noctalia-greeter = {
        enable = true;

        cursorTheme = { inherit (cursorTheme) name package; };

        settings = {
          appearance = {
            scheme = "Synced";
            theme_mode = if catppuccin.flavor == "latte" then "light" else "dark";
            font_family = ui.family;
            hide_logo = true;

            palette = {
              primary = color catppuccin.accent;
              on_primary = color "base";
              secondary = color "pink";
              on_secondary = color "base";
              tertiary = color "mauve";
              on_tertiary = color "base";
              error = color "red";
              on_error = color "base";
              surface = color "base";
              on_surface = color "text";
              surface_variant = color "surface0";
              on_surface_variant = color "subtext0";
              outline = color "overlay0";
              shadow = color "crust";
              hover = color "surface1";
              on_hover = color "text";
            };

            wallpaper = {
              path = config.profile.wallpaper;
              fill_mode = "crop";
            };
          };

          cursor.size = cursorTheme.size;
        };
      };
    };
}
