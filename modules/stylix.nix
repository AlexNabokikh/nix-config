{ inputs, ... }:
{
  flake.modules.homeManager.stylix =
    { config, lib, ... }:
    {
      imports = [ inputs.stylix.homeModules.stylix ];

      stylix = {
        enable = true;
        autoEnable = false;
        polarity = "dark";
        base16Scheme = ./profile/neovim-dark.yaml;

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
