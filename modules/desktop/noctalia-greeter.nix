{
  flake.modules.nixos.noctaliaGreeter =
    { config, ... }:
    let
      inherit (config.profile.appearance) cursorTheme;
      inherit (config.profile.appearance.fonts) ui;
    in
    {
      fonts.packages = [ ui.package ];

      services.displayManager.noctalia-greeter = {
        enable = true;

        cursorTheme = { inherit (cursorTheme) name package; };

        settings = {
          appearance = {
            scheme = "Synced";
            hide_logo = true;
          };

          cursor.size = cursorTheme.size;
        };
      };
    };
}
