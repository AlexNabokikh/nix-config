{ inputs, ... }:
{
  flake.modules.homeManager.programsNoctalia =
    {
      config,
      pkgs,
      ...
    }:
    let
      colors = import ./_colors.nix {
        inherit inputs pkgs;
        catppuccin = config.profile.appearance.catppuccin;
      };
      pluginConfig = import ./_plugins.nix;
      settings =
        (import ./_settings-desktop.nix)
        // (import ./_settings-session.nix { avatar = config.profile.avatar; })
        // (import ./_settings-ui.nix {
          uiFont = config.profile.appearance.fonts.ui.family;
          monospaceFont = config.profile.appearance.fonts.monospace.family;
        });
    in
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      home.file.".cache/noctalia/wallpapers.json".text = builtins.toJSON {
        defaultWallpaper = config.profile.wallpaper;
      };

      programs.noctalia-shell = {
        enable = true;
        inherit colors settings;
        inherit (pluginConfig) plugins pluginSettings;
        systemd.enable = true;
      };
    };
}
