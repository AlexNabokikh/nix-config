{ inputs, ... }:
{
  flake.modules.homeManager.stylix =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.stylix.homeModules.stylix ];

      stylix = {
        enable = true;
        autoEnable = false;
        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

        # Coordinate with Adwaita's dark surfaces while retaining Mocha's accents.
        override = {
          base00 = "1d1d20";
          base01 = "222226";
          base02 = "2e2e32";
          base03 = "6c6c70";
        };

        # Keep desktop appearance and system-wide font settings independent.
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
          neovim = {
            enable = true;
            plugin = "mini.base16";
          };
          opencode.enable = true;
          starship.enable = true;
          tmux.enable = true;
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
    };
}
