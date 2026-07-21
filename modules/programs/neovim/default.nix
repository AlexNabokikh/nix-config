{
  flake.modules.homeManager.neovim =
    {
      config,
      pkgs,
      ...
    }:
    {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        vimAlias = true;
        withNodeJs = true;
        withPython3 = true;
        withRuby = false;

        extraPackages = with pkgs; [
          bash-language-server
          hadolint
          lua-language-server
          markdownlint-cli
          nixd
          nixfmt
          shellcheck
          shfmt
          stylua
          tree-sitter
          yaml-language-server
        ];
      };

      xdg.configFile = {
        "nvim" = {
          source = ./lazyvim;
          recursive = true;
        };
      };

      catppuccin.nvim.enable = false;

      home.sessionVariables = {
        CATPPUCCIN_FLAVOR = config.catppuccin.flavor;
      };
    };
}
