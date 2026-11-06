{
  flake.modules.homeManager.neovim =
    {
      pkgs,
      ...
    }:
    {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        sideloadInitLua = true;
        vimAlias = true;

        extraPackages = with pkgs; [
          bash-language-server
          eslint
          golangci-lint
          gopls
          gotools
          hadolint
          helm-ls
          lua-language-server
          markdownlint-cli
          nixd
          nixfmt
          prettier
          pyright
          ruff
          shfmt
          stylua
          tflint
          tofu-ls
          tree-sitter
          vscode-langservers-extracted
          yaml-language-server
        ];
      };

      xdg.configFile = {
        "nvim" = {
          source = ./lazyvim;
          recursive = true;
        };
      };
    };
}
