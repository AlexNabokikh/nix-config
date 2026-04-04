# Module: Neovim Text Editor
# Purpose: Configures Neovim with LSP servers and development tools
# Platform: All
{pkgs, ...}: let
  neovim_config = ../../files/configs/nvim;
in {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
    withNodeJs = false; # Disabled due to build issues
    withPython3 = true;
    withRuby = true;

    extraPackages = with pkgs; [
      # Formatters
      alejandra # Nix
      black # Python
      shfmt # Shell
      stylua # Lua

      # Linters
      golangci-lint # Go
      hadolint # Dockerfile
      markdownlint-cli # Markdown
      shellcheck # Shell

      # Language Servers
      gopls # Go
      lua-language-server # Lua
      nixd # Nix
      bash-language-server # Bash
      pyright # Python
      terraform-ls # Terraform
      vscode-langservers-extracted # HTML/CSS/JSON
      yaml-language-server # YAML

      # Tools
      gotools # Go tools
      isort # Python import sorter
      prettier # Multi-language formatter
      telescope # Fuzzy finder
      tflint # Terraform linter
    ];
  };

  xdg.configFile.nvim = {
    source = "${neovim_config}";
    recursive = true;
  };
}
