{ pkgs, ... }:
{
  # Neovim text editor configuration
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraPackages = with pkgs; [
      black
      golangci-lint
      gopls
      gotools
      hadolint
      isort
      lua-language-server
      markdownlint-cli
      nixd
      nixfmt
      nodePackages.bash-language-server
      nodePackages.prettier
      pyright
      ruff
      shellcheck
      shfmt
      stylua
      terraform-ls
      tflint
      tree-sitter
      vscode-langservers-extracted
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
}
