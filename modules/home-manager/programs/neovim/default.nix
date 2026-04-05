{ ... }:
{
  flake.modules.homeManager.programsNeovim =
    {
      config,
      pkgs,
      ...
    }:
    {
      # Neovim text editor configuration
      programs.neovim = {
        enable = true;
        package = pkgs.neovim-unwrapped;
        defaultEditor = true;
        withNodeJs = true;
        withPython3 = true;
        withRuby = false;

        extraPackages = with pkgs; [
          bash-language-server
          black
          eslint
          gopls
          gotools
          hadolint
          isort
          lua-language-server
          markdownlint-cli
          nixd
          nixfmt
          prettier
          pyright
          ruff
          shellcheck
          shfmt
          stylua
          tflint
          tofu-ls
          tree-sitter
          typescript-language-server
          yaml-language-server
        ];
      };

      # source lua config from this repo
      xdg.configFile = {
        "nvim" = {
          source = ./lazyvim;
          recursive = true;
        };
      };

      # Set global catppuccin theme via env var
      home.sessionVariables = {
        CATPPUCCIN_FLAVOR = config.catppuccin.flavor;
      };
    };
}
