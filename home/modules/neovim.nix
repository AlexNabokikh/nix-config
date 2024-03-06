{pkgs, ...}: let
  neovim = ../../files/configs/nvim;
in {
  # Neovim text editor configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraPackages = with pkgs; [
      alejandra
      ansible-language-server
      ansible-lint
      black
      dockerfile-language-server-nodejs
      golangci-lint
      golangci-lint-langserver
      gopls
      gotools
      hadolint
      isort
      lua-language-server
      markdownlint-cli
      marksman
      nil
      nodePackages.bash-language-server
      nodePackages.prettier
      nodePackages.pyright
      ruff
      ruff-lsp
      shellcheck
      shfmt
      stylua
      terraform-ls
      tflint
      vscode-langservers-extracted
      yaml-language-server
    ];
  };

  home.file.".config/nvim" = {
    source = "${neovim}";
    recursive = true;
  };
}
