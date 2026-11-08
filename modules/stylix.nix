{ inputs, ... }:
{
  flake.modules.homeManager.stylix =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      colors = config.lib.stylix.colors.withHashtag;
    in
    {
      imports = [ inputs.stylix.homeModules.stylix ];

      stylix = {
        enable = true;
        autoEnable = false;
        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

        # Adwaita's dark surfaces with Catppuccin Mocha's accents.
        override = {
          base00 = "1d1d20";
          base01 = "222226";
          base02 = "2e2e32";
          base03 = "6c6c70";
        };

        targets = {
          alacritty = {
            enable = true;
            fonts.enable = false;
            opacity.enable = false;
          };
          btop.enable = true;
          fzf.enable = true;
          k9s.enable = true;
          lazygit.enable = true;
          opencode.enable = true;
          starship.enable = true;
        };
      };

      # The pinned Stylix target generates the theme but selects it via V1's tui.json.
      programs.opencode = lib.mkIf config.stylix.targets.opencode.enable {
        tui = lib.mkForce { };
        cli.theme = {
          name = "stylix";
          mode = "dark";
        };
      };

      # Match other TUIs: regular text instead of base04 and no rosewater highlight.
      programs.fzf.colors = lib.mkIf config.stylix.targets.fzf.enable (
        with colors;
        {
          fg = lib.mkForce base05;
          "fg+" = lib.mkForce base05;
          "bg+" = lib.mkForce base02;
          gutter = base00;
          border = base03;
        }
      );
    };
}
