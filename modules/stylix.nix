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

      # tinted-tmux predates tmux theme colours, which popups and menus default to.
      programs.tmux.extraConfig = lib.mkIf config.stylix.targets.tmux.enable (
        with colors;
        lib.mkAfter ''
          set -s theme dark
          set -s dark-theme-black "${base00}"
          set -s dark-theme-dark-grey "${base01}"
          set -s dark-theme-light-grey "${base03}"
          set -s dark-theme-white "${base05}"
          set -s dark-theme-red "${base08}"
          set -s dark-theme-yellow "${base0A}"
          set -s dark-theme-green "${base0B}"
          set -s dark-theme-cyan "${base0C}"
          set -s dark-theme-blue "${base0D}"
          set -s dark-theme-magenta "${base0E}"

          # Share the fzf background so popup borders and content match.
          set -g popup-style "bg=${base00},fg=${base05}"
          set -g popup-border-style "bg=${base00},fg=${base03}"
        ''
      );
    };
}
