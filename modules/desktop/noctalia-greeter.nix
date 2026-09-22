{
  flake.modules.nixos.noctaliaGreeter =
    { config, ... }:
    let
      inherit (config.profile.appearance) catppuccin cursorTheme;
      inherit (config.profile.appearance.fonts) ui;
    in
    {
      fonts.packages = [ ui.package ];

      services.displayManager.noctalia-greeter = {
        enable = true;

        cursorTheme = { inherit (cursorTheme) name package; };

        settings = {
          appearance = {
            scheme = "Catppuccin";
            theme_mode = if catppuccin.flavor == "latte" then "light" else "dark";
            font_family = ui.family;
            hide_logo = true;

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
